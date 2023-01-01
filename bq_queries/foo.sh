tables=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site")

# for tbl in ${tables[@]} 
# do
#     MATCH="\b$tbl\b[^.]"
#     SRC="$tbl"
#     DEST="'$tbl.parquet' AS $tbl"
#     echo "$MATCH $SRC $DEST"
#     sed -i "/$MATCH/  s/$SRC/$DEST/g" *.sql
# done

for tbl in ${tables[@]} 
do
    SRC="'$tbl.parquet'"
    DEST="\`arachne-multicloud.tpcds.$tbl\`"
    echo "$SRC $DEST"
    sed -i "s/$SRC/$DEST/g" *.sql
done

