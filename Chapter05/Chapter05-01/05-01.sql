/*演習5-1 結合が先か、集約が先か?

使用するテーブル

年齢テーブル(AgeTable)
 age_class | age_range
-----------+-----------
 1         | 21〜30歳
 2         | 31〜40歳
 3         | 41〜50歳

性別テーブル(SexTable)
 sex_code | sex_name
----------+----------
 m        | 男
 f        | 女

人口テーブル(PopulationTable)
 prefecture_name | age_class | sex_code | prefecture_population
-----------------+-----------+----------+-----------------------
 秋田            | 1         | m        |                   400
 秋田            | 3         | m        |                  1000
 秋田            | 1         | f        |                   800
 秋田            | 3         | f        |                  1000
 青森            | 1         | m        |                   700
 青森            | 1         | f        |                   500
 青森            | 3         | f        |                   800
 東京            | 1         | m        |                   900
 東京            | 1         | f        |                  1500
 東京            | 3         | f        |                  1200
 千葉            | 1         | m        |                   900
 千葉            | 1         | f        |                  1000
 千葉            | 3         | f        |                   900


「クロス表で入れ子の表側を作る」(p.87)では、集約してDATAビューとMASTERビュー
の対応を一対一にしてから結合を行いました。これはこれで分かりやすい方法ですが、
パフォーマンスを考慮するならば、中間ビューを二つ作るのは無駄が多い方法です。
そこで、この中間ビューをなるべく減らすように、コードを改良してください。*/

--取得値
SELECT

	--年齢層
	MasterTable.age_class AS age_class,
	
	--性別コード
	MasterTable.sex_code AS sex_code,
	
	--年齢層・性別コードごとの東北人口
	SUM (Case WHEN prefecture_name IN ('秋田', '青森') THEN prefecture_population ELSE NULL END) AS 東北,
	
	--年齢層・性別コードごとの東北人口
	SUM (Case WHEN prefecture_name IN ('東京' ,'千葉') THEN prefecture_population ELSE NULL END) AS 関東
	

--参照範囲
FROM

	--表側を年齢層・性別コードの掛け合わせで表記するためのマスタテーブルを用意する
	(
		--取得列
		SELECT 
		
			--年齢層
			age_class, 
			
			--性別コード
			sex_code
	
		--参照範囲
		FROM 
		
			--年齢テーブルと
			AgeTable 
		
		--クロス結合を行うのは
		CROSS JOIN 
		
			--性別テーブル
			SexTable 
			
	--上記で作成したテーブルにエイリアスを付ける
	) AS MasterTable
	
--マスタテーブルに存在して人口テーブルに存在しない年齢層'2'の行を表示したいので、左外部結合
LEFT JOIN

	--人口テーブル
	PopulationTable

--結合条件	
ON 

	--両テーブルの年齢層が同じ
	MasterTable.age_class = PopulationTable.age_class

--かつ
AND

	--性別コードが同じ
	MasterTable.sex_code = PopulationTable.sex_code
	
--年齢層・性別コードごとの人口を表示するためのグループ化キー値
GROUP BY

	--年齢層
	MasterTable.age_class,
	
	--性別コード
	MasterTable.sex_code
	
--教科書と同じ並びにするためのソート
ORDER BY

	--年齢層について昇順
	age_class ASC,
	
	--性別コードについて降順
	sex_code DESC
	
;

/*出力
 age_class | sex_code | 東北 | 関東
-----------+----------+------+------
 1         | m        | 1100 | 1800
 1         | f        | 1300 | 2500
 2         | m        |      |
 2         | f        |      |
 3         | m        | 1000 |
 3         | f        | 1800 | 2100
*/
