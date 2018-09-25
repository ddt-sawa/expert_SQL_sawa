/*演習2-1 重複組み合わせ
 p.29のProductsテーブルを使って、2列の重複組み合わせを求めてみてください。
結果は次のようになります。

 product_name | product_name
--------------+--------------
 バナナ       | りんご
 バナナ       | みかん
 バナナ       | バナナ
 りんご       | りんご
 りんご       | みかん
 みかん       | みかん
 
組み合わせですから(バナナ、みかん)と(みかん、バナナ)のような順序を入れ替えた
だけのペアは同じとみなしますが、重複を許すので(みかん、みかん)のような
ペアも現れます。*/
  
--取得列
SELECT 

	--組み合わせ1
	FirstProductsTable.PRODUCT_NAME,
	
	--組み合わせ2  
	SecondProductsTable.PRODUCT_NAME

--参照範囲	
FROM

	--商品テーブルを
	ProductsTable AS FirstProductsTable,

	--自己クロス結合したテーブル
	ProductsTable AS SecondProductsTable
	
--取得条件
WHERE

	--組み合わせ1が組み合わせ2以上のレコードを取得することで非順序対にする
	FirstProductsTable.PRODUCT_NAME >= SecondProductsTable.PRODUCT_NAME
	
--ソート
ORDER BY

	--組み合わせ1について降順
	FirstProductsTable.PRODUCT_NAME DESC
;	
