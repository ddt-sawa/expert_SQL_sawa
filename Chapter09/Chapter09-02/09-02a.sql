/*演習9-2 シーケンスを求める--集合指向的発想

使用するテーブル
座席テーブル(SeatsTable)
 seat_id | seat_status
---------+-------------
       1 | 占
       2 | 占
       3 | 空
       4 | 空
       5 | 空
       6 | 占
       7 | 空
       8 | 空
       9 | 空
      10 | 空
      11 | 空
      12 | 占
      13 | 占
      14 | 空
      15 | 空

「3人なんですけど、座れますか?」では、NOT EXISTSで全称量化を表現することによって、
シーケンスを求めました。これをHAVING句を使って書き換えてください。
行に折り返しがないケースが解けたら、折り返しがあるケースも考えてみてください。

a.行の折り返しを考慮しない
*/

--取得値
SELECT

	--3席以上空いているスペースの始点
	StartTable.seat_id AS 始点,
	
	--レイアウト用文字
	'〜',
	
	--3席以上空いているスペースの終点
	 EndTable.seat_id AS 終点
	
--参照範囲
FROM

	--始点用座席テーブルと終点用座席テーブルのクロス結合
	SeatsTable AS StartTable, SeatsTable AS EndTable

--参照条件
WHERE

	--終点の席番号が始点の席番号+2
	EndTable.seat_id = StartTable.seat_id + (3 - 1)

--始点と終点についてグループ化
GROUP BY

	--始点の席番号
	StartTable.seat_id,

	--終点の席番号
	EndTable.seat_id

--取得条件
HAVING

	--始点・終点間空席数を調べるサブクエリ
	(
		--取得値
		SELECT
	
			--始点・終点間の空席の数
	 		COUNT(QueryTable.seat_id) 
	 
		--参照範囲
	 	FROM
	  
			--始点・終点間用座席テーブル
	 		SeatsTable AS QueryTable 
	 
		--取得条件
		WHERE 
	 
			--空席かどうか調べている座席が始点・終点間に存在しており
			QueryTable.seat_id BETWEEN StartTable.seat_id AND EndTable.seat_id
	 
		--かつ
		AND 
	 		
			--その座席が空席
	 		QueryTable.seat_status = '空' 
	 
	--始点・終点間空席数が3の場合条件を満たす
	) = 3
 
--教材と同じ順に並び替え
ORDER BY

	--始点座席番号について昇順
	StartTable.seat_id ASC
	
;

/*出力
 始点 | ?column? | 終点
------+----------+------
    3 | 〜       |    5
    7 | 〜       |    9
    8 | 〜       |   10
    9 | 〜       |   11
*/
