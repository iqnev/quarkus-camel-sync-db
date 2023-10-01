package org.camel.demo;

import org.apache.camel.builder.RouteBuilder;

public class CustomersRoutes extends RouteBuilder {

  @Override
  public void configure() throws Exception {

    from("timer:customersSync?period=30000")
        .to(
            "sql:SELECT MAX(last_modified) FROM customers?dataSource=#targetShipcars&outputType=SelectOne")
        .choice()
        .when(body().isNotNull())
        .setHeader("lastModifiedParam", simple("${body}"))
        .log("[CustomersRoutes] Set lastModifiedParam header to: ${header.lastModifiedParam}")
        .otherwise()
        .log("[CustomersRoutes] Body is null or empty. Not setting lastModifiedParam header.")
        .end()
        .to("direct:syncCustomers");

    from("direct:syncCustomers")
        .log(
            "[CustomersRoutes] Synchronizing customers table with lastModifiedParam: ${header.lastModifiedParam}")
        .choice()
        .when(body().isNull())
        .to(
            "sql:SELECT customer_id, first_name, last_name, email, phone_number, address, created_at, last_modified FROM customers LIMIT 10?dataSource=#sourceShipcars")
        .otherwise()
        .to(
            "sql:SELECT customer_id, first_name, last_name, email, phone_number, address, created_at, last_modified "
                + "FROM customers WHERE last_modified > :#${header.lastModifiedParam}?dataSource=#sourceShipcars")
        .end()
        .choice()
        .when(body().isNull())
        .log("[CustomersRoutes] No data retrieved. Body: ${body}, Headers: ${headers}")
        .otherwise()
        .log("[CustomersRoutes] Data retrieved. Body: ${body}, Headers: ${headers}")
        .split(body())
        .streaming()
        .to(
            "sql:INSERT INTO customers AS c (customer_id, first_name, last_name, email, phone_number, address, created_at, last_modified) "
                + "VALUES (:#customer_id, :#first_name, :#last_name, :#email, :#phone_number, :#address, :#created_at, :#last_modified) "
                + "ON CONFLICT (customer_id) DO UPDATE SET first_name = :#first_name, last_name = :#last_name, "
                + "email = :#email, phone_number = :#phone_number, address = :#address, created_at = :#created_at, "
                + "last_modified = :#last_modified WHERE c.customer_id = :#customer_id?dataSource=#targetShipcars")
        .end()
        .log("[CustomersRoutes] Sending to syncCars, Headers: ${headers}")
        .to("direct:syncCars")
        .end();
  }
}
