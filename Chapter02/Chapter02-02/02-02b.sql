/*演習2-2 地域ごとのランキング
 p36の「ランキング」では、テーブル全体の中でランキングを求めました。今度は「地方」
列も付け加えたテーブルを用意して、地域ごとにランキングを求めてみましょう。 
 例によって、値段の高い順にランキングして、同順位が続いたら順位を飛び石にします。
結果は次のようになります。一つのテーブル全体の順位ではなく、小さな
部分集合に切り分けた中での順位を求めるのがポイントです。
 district_name | product_name | product_price | price_rank
---------------+--------------+---------------+------------
 東北          | みかん       |           100 |          1
 東北          | りんご       |            50 |          2
 東北          | ぶどう       |            50 |          2
 東北          | レモン       |            30 |          4
 関東          | レモン       |           100 |          1
 関東          | パイン       |           100 |          1
 関東          | りんご       |           100 |          1
 関東          | ぶどう       |            70 |          4
 関西          | レモン       |            70 |          1
 関西          | スイカ       |            30 |          2
 関西          | りんご       |            20 |          3

解き方は、やはりOLAP関数と自己結合を使う二通りがあります。(スカラ・サブクエリと
結合を別解答と考えれば3通り)。それぞれ考えてみてください。

b.自己結合を使用する*/

--取得列
SELECT

	--地域名
	DISTRICT_NAME,
	
	--商品名
	PRODUCT_NAME,
	
	--単価
	PRODUCT_PRICE,

	--地域ごとに、検討中レコードより単価が高い集合の数を求めるサブクエリ
	(	
		--取得値
		SELECT
		 	
			--自身より単価が高い集合の数
			COUNT(SecondDistrictTable.PRODUCT_PRICE)
	
		--参照範囲
		FROM
	
			--地域別商品テーブル
			DistrictProductsTable AS SecondDistrictTable
		
		--取得条件	
		WHERE
		
			--地域内でのランク付けを行うため、同じ地域名のレコードであること
			SecondDistrictTable.DISTRICT_NAME = FirstDistrictTable.DISTRICT_NAME
		
		--かつ
		AND
			
			--自身より単価が高い
			SecondDistrictTable.PRODUCT_PRICE > FirstDistrictTable.PRODUCT_PRICE
		
	--自身より単価が高い集合の数 + 1をランクとして出力	
	) + 1 AS PRICE_RANK
			
			
--参照範囲
FROM

	--地域別商品テーブル
	DistrictProductsTable AS FirstDistrictTable
;


