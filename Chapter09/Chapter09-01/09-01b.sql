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

b.外部結合を使用*/

--取得値
SELECT

	--欠番
	NumberTable.number AS 欠番
	
--参照範囲
FROM

	--自然数テーブル
	NumberTable 
	
--自然数テーブルに対して欠番テーブルが持っていない値をNULLとして出力するため、左外部結合を行う
LEFT OUTER JOIN

	--欠番テーブル
	MissingNumberTable

	
--結合キー値
ON
	--値
	NumberTable.number = MissingNumberTable.number
	
	
--取得条件	
WHERE

	--欠番テーブルの最小値から
	NumberTable.number BETWEEN (SELECT MIN(MissingNumberTable.number) FROM MissingNumberTable)
	
	--最大値の間
	AND (SELECT MAX(MissingNumberTable.number) FROM MissingNumberTable)

--取得条件その2	
AND

	--欠番テーブルに値がない
	MissingNumberTable.number IS NULL
;

/*出力

 欠番
------
    3
    9
   10*/
