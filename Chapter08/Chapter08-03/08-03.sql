/*演習8-3 

使用テーブル
 
自然数テーブル(NumberTable)
 number
--------
      1
      2
〜〜〜〜
     100

100以下の素数をすべて求めてください。*/

--取得値
SELECT

	--素数
	number AS 素数
	

--参照範囲
FROM

	--自然数テーブル
	NumberTable AS MasterTable
	
--素数である条件
WHERE

	--1以上
	number > 1
	
--かつ
AND

	--1とその数自身以外に正の約数が存在しない
	NOT EXISTS 
	
	--検討中の値に対して1とその数自身以外に正の約数が存在しないかどうかを調べるサブクエリ
	(
		--取得値
		SELECT
		
			--全列
			*
			
	 --参照範囲
	 FROM
	 
		--約数用自然数テーブル
		NumberTable AS DivisorTable
		
	--約数の取得条件
	WHERE
		
		--1ではない
		DivisorTable.number <> 1
		
	--かつ	
	AND
	
		--検討中の値より小さい
		MasterTable.number > DivisorTable.number
		
	--かつ	
	AND
	
		--検討中の値の正の約数
		MasterTable.number % DivisorTable.number = 0
	)
	
--表示順
ORDER BY

	--素数について昇順
	number ASC
;
