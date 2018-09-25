/* 演習1-2 合計と再掲を表頭に出力する行列変換
 本文中のPoptbl2をサンプルに浸かって、行持ちから列持ちへの水平展開の
 練習をもう少ししておきましょう。今度は、次のように表頭に合計や再掲の列を
 持つようなクロス表を作ってください。*/
 
--取得値
SELECT 
	
	--性別について場合分け
	CASE 
	
		--性別欄が1の場合'男'を
		WHEN PREFECUTURE_SEX = '1' THEN '男'
		
		--性別欄が2の場合'女'を
		WHEN PREFECUTURE_SEX = '2' THEN '女'
		
		--そうでない場合NULLを
		ELSE NULL 
		
		--性別欄に出力
		END AS 性別,
	
	--性別ごとの人口総計
	SUM(PREFECTURE_POPULATION) AS 全国,
	
	--性別ごとの徳島人口総計
	SUM(CASE WHEN PREFECTURE_NAME = '徳島' THEN PREFECTURE_POPULATION ELSE 0 END) AS 徳島,
	
	--性別ごとの香川人口総計
	SUM(CASE WHEN PREFECTURE_NAME = '香川' THEN PREFECTURE_POPULATION ELSE 0 END) AS 香川,
	
	--性別ごとの愛媛人口総計
	SUM(CASE WHEN PREFECTURE_NAME = '愛媛' THEN PREFECTURE_POPULATION ELSE 0 END) AS 愛媛,
	
	--性別ごとの高知人口総計
	SUM(CASE WHEN PREFECTURE_NAME = '高知' THEN PREFECTURE_POPULATION ELSE 0 END) AS 高知,
	
	--性別ごとの四国人口総計
	SUM(CASE WHEN PREFECTURE_NAME IN ('徳島', '香川', '愛媛', '高知') THEN PREFECTURE_POPULATION ELSE 0 END) AS 四国

--参照範囲
FROM

	--都道府県別人口テーブル
	PopTable2
	

--グループ化のキー値
GROUP BY

	--性別欄
	PREFECUTURE_SEX

--ソート
ORDER BY

	--性別について昇順
	PREFECUTURE_SEX ASC

;
/*出力

 */
