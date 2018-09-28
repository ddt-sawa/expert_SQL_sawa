/*演習9-2 シーケンスを求める--集合指向的発想

使用するテーブル
折り返し座席テーブル(FlapTable)
 seat_number | row_index | seat_index
-------------+-----------+------------
           1 | A         | 占
           2 | A         | 占
           3 | A         | 空
           4 | A         | 空
           5 | A         | 空
           6 | B         | 占
           7 | B         | 占
           8 | B         | 空
           9 | B         | 空
          10 | B         | 空
          11 | C         | 空
          12 | C         | 空
          13 | C         | 空
          14 | C         | 占
          15 | C         | 空

「3人なんですけど、座れますか?」では、NOT EXISTSで全称量化を表現することによって、
シーケンスを求めました。これをHAVING句を使って書き換えてください。
行に折り返しがないケースが解けたら、折り返しがあるケースも考えてみてください。

b.行の折り返しを考慮する
*/

--取得値
SELECT

	--3席以上空いているスペースの始点
	StartTable.seat_number AS 始点,
	
	--レイアウト用文字
	'～',
	
	--3席以上空いているスペースの終点
	
	 EndTable.seat_number AS 終点
	
--参照範囲
FROM

	--始点用座席テーブルと終点用座席テーブルのクロス結合
	FlapTable AS StartTable, FlapTable AS EndTable

--参照条件
WHERE

	--終点の席番号が始点の席番号+2
	EndTable.seat_number = StartTable.seat_number + (3 - 1)

--始点と終点についてグループ化
GROUP BY

	--始点の席番号
	StartTable.seat_number,
	
	--始点の行番号
	StartTable.row_index,

	--終点の席番号
	EndTable.seat_number,
	
	--終点の行番号
	EndTable.row_index

--取得条件
HAVING

	--始点・終点間空席数を調べるサブクエリ
	(
		--取得値
		SELECT
	
			--始点・終点間の空席の数
	 		COUNT(QueryTable.seat_number) 
	 
		--参照範囲
	 	FROM
	  
			--始点・終点間用座席テーブル
	 		FlapTable AS QueryTable 
	 
		--取得条件
		WHERE 
	 
			--空席かどうか調べている座席が始点・終点間に存在しており
			QueryTable.seat_number BETWEEN StartTable.seat_number AND EndTable.seat_number
	 
		--かつ
		AND 
	 		
			--その座席が空席
	 		QueryTable.seat_index = '空'
		
		--かつ	
		AND 
		
			--その座席が始点と同じ行に備え付けられている
			QueryTable.row_index = StartTable.row_index
	 
	--始点・終点間空席数が3の場合条件を満たす
	) = 3
 
--教材と同じ順に並び替え
ORDER BY

	--始点座席番号について昇順
	StartTable.seat_number ASC	
;
/*
 始点 | ?column? | 終点
------+----------+------
    3 | ～       |    5
    8 | ～       |   10
   11 | ～       |   13
*/

