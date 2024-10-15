import Config

config :store,
  pricing_rules: "priv/data/pricing_rules.csv",
  products: "priv/data/products.csv",
  discount_ets: :discount_table,
  product_ets: :product_table
