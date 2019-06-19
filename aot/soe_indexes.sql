-- undo optimizations to bad scalability

-- ALTER SEQUENCE SOE.ORDERS_SEQ NOORDER CACHE 2;  -- enq: SV
ALTER SEQUENCE SOE.ORDERS_SEQ NOORDER CACHE 2;   -- enq: SQ

--@disable_restricting_fks SOE.ORDERS
ALTER TABLE SOE.ORDER_ITEMS DISABLE CONSTRAINT ORDER_ITEMS_ORDER_ID_FK;
ALTER TABLE soe.orders DISABLE CONSTRAINT order_pk;

DROP INDEX soe.order_pk;
DROP INDEX soe.ord_order_date_ix;

CREATE UNIQUE INDEX SOE.ORDER_PK ON SOE.ORDERS (ORDER_ID) 
NOLOGGING TABLESPACE SOE PARALLEL 4;

CREATE INDEX SOE.ORD_ORDER_DATE_IX ON SOE.ORDERS (ORDER_DATE) 
NOLOGGING TABLESPACE SOE PARALLEL 4;

CREATE BITMAP INDEX SOE.ORDER_MAGIC ON SOE.ORDERS(ORDER_ID,ORDER_DATE)
NOLOGGING TABLESPACE SOE PARALLEL 4;

ALTER INDEX SOE.ORDER_PK NOPARALLEL;
ALTER INDEX SOE.ORD_ORDER_DATE_IX NOPARALLEL;
ALTER INDEX SOE.ORDER_MAGIC NOPARALLEL;

ALTER TABLE soe.orders ENABLE VALIDATE CONSTRAINT order_pk;



ALTER SESSION SET ddl_lock_timeout = 10;

ALTER TABLE soe.orders ENABLE VALIDATE CONSTRAINT order_pk;
ALTER TABLE soe.orders ENABLE VALIDATE CONSTRAINT orders_customer_id_fk;


-- reverse key
-- recreate above indexes with REVERSE flag

