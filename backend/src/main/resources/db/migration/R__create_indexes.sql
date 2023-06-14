CREATE INDEX idx_order_product_product_id_order_id ON public.order_product USING btree (product_id, order_id);
CREATE INDEX idx_order_id ON public.orders USING btree (id);
CREATE INDEX idx_product_id ON public.product USING btree (id);