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

a.自己結合を使う*/

--更新を行う表
UPDATE
	
	--地域別商品テーブル
	RankingNullTable AS FirstRankingTable
	
	--NULLになっている単価ランキングの更新を行う
	SET PRICE_RANKING =
	
		--地域ごとの単価ランキングを求めるサブクエリ
		(
			--取得値
			SELECT 
			
				--同じ地域名かつ自身より単価が高いレコードの数
				COUNT(*)
		
			--参照範囲
			FROM
			
				--地域別商品テーブル
				RankingNullTable AS SecondRankingTable
			
			--取得条件	
			WHERE
			
				--地域名が同じ
				FirstRankingTable.DISTRICT_NAME = SecondRankingTable.DISTRICT_NAME
			
			--かつ
			AND
			
				--自身より単価が高いレコード
				SecondRankingTable.PRODUCT_PRICE > FirstRankingTable.PRODUCT_PRICE
		
		--自身より単価が高いレコードの数 + 1をランクとして設定する
		) + 1
;
