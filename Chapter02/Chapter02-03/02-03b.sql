/*演習2-3 ランキングの更新
 もう一つランキングを題材にした練習をしておきましょう。
次のように、順位列が最初からテーブルに用意されているとします。
 
 district_name | product_name | product_price | price_ranking
---------------+--------------+---------------+---------------
 東北          | みかん       |           100 |
 東北          | りんご       |            50 |
 東北          | ぶどう       |            50 |
 東北          | レモン       |            30 |
 関東          | レモン       |           100 |
 関東          | パイン       |           100 |
 関東          | りんご       |           100 |
 関東          | ぶどう       |            70 |
 関西          | レモン       |            70 |
 関西          | スイカ       |            30 |
 関西          | りんご       |            20 |
 
 ただし、順位の初期値はオールNULLです。皆さんにやってほしいのは、この列に
順位を入れることです。この場合、自己結合を使うには何の問題もないのですが、
OLAP関数を使おうとすると、ちょっとクリアすべき壁に突き当たります。

b.OLAP関数を使う*/

--更新を行う表
UPDATE
	
	--地域別商品テーブル
	RankingNullTable
	
	--商品単価ランキングをサブクエリから取得
	SET PRICE_RANKING = 
	
		--PostgreSQLではSET句でRANK関数が使えないので、サブクエリ内でRANK関数を適用する
		( 
			--取得列
			SELECT
			
				--地域ごとの商品単価ランキング
				TemporaryTable.Temporary_RANKING
				
			--参照範囲
			FROM
				
				--課題の制限上自己結合を使ってはいけないので、取得したレコードを別の名前で保存するサブクエリ
				(
					--取得列
					SELECT 
					
						--地域名
						DISTRICT_NAME,
						
						--商品名
						PRODUCT_NAME,
						
						--単価
						PRODUCT_PRICE,
						
						--地域ごとの商品単価ランキング
						RANK() OVER(PARTITION BY DISTRICT_NAME ORDER BY PRODUCT_PRICE DESC) AS TEMPORARY_RANKING
						
					
					--参照範囲
					FROM
					
						--地域別商品テーブル
						RankingNullTable
						
				--取得したレコード群を別の名前に保存
				) AS TemporaryTable
				
			--取得条件
			WHERE 
			
				--商品単価テーブルと一時テーブルの地域名が等しく、
				TemporaryTable.DISTRICT_NAME = RankingNullTable.DISTRICT_NAME
				
			--かつ
			AND
			
				--商品名も等しい
				TemporaryTable.PRODUCT_NAME = RankingNullTable.PRODUCT_NAME
		)	
;
