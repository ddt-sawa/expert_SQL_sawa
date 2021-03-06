/*演習6-3 SUMを使えば累計、ではMAX,MIN,AVGでは？
「移動累計と移動平均」(p.111)の最初に、累計を求めるクエリを紹介しました。
このクエリのSUM関数をMAXに変えた場合は、どんな結果になるでしょう？
またそれは、何を意味する数値になるでしょう？
MAXのケースはできたら、MINやAVGに変えた場合も考えてみてください。
ただし、実際にクエリを実行する前に、自分の頭で考えて、それから確認してください。

a.MAXでの書き換え

考察
その日までの最も値が大きい前日差額が表示されるものと思われる*/

--取得値
SELECT 

	--処理日
	process_date,
	
	--差額
	process_amount,
	
	--その日までの最も値が大きい前日差額
	MAX(process_amount) OVER (ORDER BY process_date) AS onhand_max

--参照範囲	
FROM 

	--入出金テーブル
	AccountTable
;

/*出力
 process_date | process_amount | onhand_max
--------------+----------------+------------
 2006-10-26   |          12000 |      12000
 2006-10-28   |           2500 |      12000
 2006-10-31   |         -15000 |      12000
 2006-11-03   |          34000 |      34000
 2006-11-04   |          -5000 |      34000
 2006-11-06   |           7200 |      34000
 2006-11-11   |          11000 |      34000
 
考察が正しかったように思われる。
*/
