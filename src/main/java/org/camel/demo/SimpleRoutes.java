package org.camel.demo;

import org.apache.camel.builder.RouteBuilder;

public class SimpleRoutes extends RouteBuilder {

  @Override
  public void configure() throws Exception {

    from("timer:databaseSync?period=30000")
        .to(
            "sql:SELECT MAX(last_modified) FROM public.user?dataSource=#targetSimple&outputType=SelectOne")
        .choice()
        .when(simple("${body} != null"))
        .log("Maximum last_modified value: ${body}")
        .setHeader("lastModifiedParam", simple("${body}"))
        .end()
        .to("direct:processData");

    from("direct:processData")
        .log("The last_modified from source DB: ${body}")
        .setHeader("lastModifiedParam", simple("${body}"))
        .choice()
        .when(simple("${body} == null"))
        .to(
            "sql:SELECT user_id, username, password, email, created_at, last_modified FROM public.user LIMIT 10?dataSource=#sourceSimple")
        .otherwise()
        .to(
            "sql:SELECT user_id, username, password, email, created_at, last_modified FROM public.user WHERE last_modified > :#${header.lastModifiedParam}?dataSource=#sourceSimple")
        .end()
        .log("Processed data: ${body}")
        .split(body())
        .streaming()
        .choice()
        .when(simple("${body} != null"))
        .toD(
            "sql:INSERT INTO public.user (user_id, username, password, email, created_at, last_modified) VALUES (:#user_id, :#username, :#password, :#email, :#created_at, :#last_modified) ON CONFLICT (user_id) DO UPDATE SET username = :#username, password = :#password, email = :#email, created_at = :#created_at, last_modified = :#last_modified WHERE public.user.user_id = :#user_id?dataSource=#targetSimple")
        .endChoice();
  }
}
