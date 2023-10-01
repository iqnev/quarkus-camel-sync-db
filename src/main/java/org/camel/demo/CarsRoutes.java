package org.camel.demo;

import java.util.List;

import org.apache.camel.builder.RouteBuilder;

public class CarsRoutes extends RouteBuilder {

  @Override
  public void configure() throws Exception {
    from("direct:syncCars")
        .log("[CarsRoutes] Synchronizing cars for customers, Headers: ${headers}")
        .choice()
        .when(simple("${headers.lastModifiedParam} == null"))
        .to(
            "sql:SELECT car_id, make, model, year, vin, owner_id, created_at, last_modified FROM cars LIMIT 10?dataSource=#sourceShipcars")
        .otherwise()
        .to(
            "sql:SELECT car_id, make, model, year, vin, owner_id, created_at, last_modified FROM cars WHERE last_modified > :#${header.lastModifiedParam}?dataSource=#sourceShipcars")
        .end()
        .choice()
        .when(body().isNull())
        .log("[CarsRoutes] No data retrieved. Body: ${body}, Headers: ${headers}")
        .otherwise()
        .split()
        .body(List.class)
        .streaming()
        .to(
            "sql:INSERT INTO cars AS c (car_id, make, model, year, vin, owner_id, created_at, last_modified) "
                + "VALUES (:#car_id, :#make, :#model, :#year, :#vin, :#owner_id, :#created_at, :#last_modified) "
                + "ON CONFLICT (car_id) DO UPDATE SET make = :#make, model = :#model, year = :#year, vin = :#vin, "
                + "owner_id = :#owner_id, created_at = :#created_at, last_modified = :#last_modified "
                + "WHERE c.car_id = :#car_id?dataSource=#targetShipcars")
        .log("[CustomersRoutes] Sending to syncPayments, Headers: ${headers}")
        // .to("direct:syncPayments")
        .end();
  }
}
