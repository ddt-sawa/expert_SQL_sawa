/*演習問題9-1 欠番を全て求める--NOT EXISTSと外部結合 

使用するテーブル

自然数テーブル(NumberTable)
 number
--------
      1
      2
〜〜〜〜
     100
	 

歯抜けテーブル(MissingNumbetTable)
 number
--------
      1
      2
      4
      5
      6
      7
      8
     11
     12

本文にも書いたように、SQLで差集合演算を実現する方法は多くあります。
文中ではEXCEPTとNOT INを使ったものを紹介しました。ここでは
NOT EXISTSと外部結合を使う方法を考えてみてください。

a.NOT EXISTS を使用*/

--取得値
SELECT

	--欠番
	NumberTable.number AS 欠番
	
--参照範囲
FROM

	--自然数テーブル
	NumberTable
	
--取得条件	
WHERE

	--欠番テーブルの最小値から
	NumberTable.number BETWEEN (SELECT MIN(MissingNumberTable.number) FROM MissingNumberTable)
	
	--最大値の間
	AND (SELECT MAX(MissingNumberTable.number) FROM MissingNumberTable)
	
--取得条件2
AND

	--欠番テーブルに値が存在しない
	NOT EXISTS 
	
		--自然テーブルと欠番テーブル両方に存在する値を調べるサブクエリ
		(
			--取得値
			SELECT
		
				--全列
				*
				
			--参照範囲
			FROM
			
				--欠番テーブル
				MissingNumberTable
				
			--取得条件
			WHERE
			
			--値が自然テーブルと欠番テーブル両方に存在する
			NumberTable.number = MissingNumberTable.number
		)
;

/*出力

 欠番
------
    3
    9
   10*/
