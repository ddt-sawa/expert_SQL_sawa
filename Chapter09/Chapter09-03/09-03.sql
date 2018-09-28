/*演習9-3 シーケンスを全て求める--集合指向的発想

使用するテーブル
座席テーブル(MaxTable)
 seat_id | seat_status
---------+-------------
       1 | 占
       2 | 空
       3 | 空
       4 | 空
       5 | 空
       6 | 占
       7 | 空
       8 | 占
       9 | 空
      10 | 空

引き続き、述語論理を集合論に変換する練習です。「最大何人まで座れますか?」
でNOT EXISTSを使って求めたシーケンスを全て保持するビューのクエリを、
HAVING句で書き換えてください。基本的には演習問題2と同じ考え方でいいのですが、
特性関数の条件がちょっと複雑になります。*/

--空席の連続状況(シーケンス)を保存するビューをHAVING句を用いて作成する
CREATE VIEW 
	--空席シーケンスビュー
	SeatView AS
--取得値
SELECT
	--始点
	StartTable.seat_id AS start_seat,
	
	--終点
	EndTable.seat_id AS end_seat,
	 
	--最大連続空席数
	EndTable.seat_id - StartTable.seat_id + 1 AS vacancy_number 
--参照範囲(クロス結合)
FROM
	--始点用座席テーブル
	MaxTable AS StartTable,
	
	--終点用座席テーブル
	MaxTable AS EndTable,
	
	--走査用テーブル
	MaxTable AS MiddleTable 
--取得条件
WHERE
	--始点座席番号が終点座席番号以前にある
	StartTable.seat_id <= EndTable.seat_id
--かつ
AND 
	--走査座席番号が始点座席番号から終点座席番号の間
	MiddleTable.seat_id BETWEEN StartTable.seat_id - 1 AND EndTable.seat_id + 1
--始点と終点についてグループ化
GROUP BY
	--始点の席番号
	StartTable.seat_id,

	--終点の席番号
	EndTable.seat_id
--取得条件
HAVING	
	--走査すべき全座席が下記の条件群のいずれかを満たしている
	COUNT(*) = SUM(
					
					--走査中座席が始点の一つ前にあり、かつ占席である
					CASE WHEN MiddleTable.seat_id = StartTable.seat_id - 1 AND MiddleTable.seat_status = '占' THEN 1
		
					--走査中座席が終点の一つ後にあり、かつ占席である
			 		WHEN MiddleTable.seat_id = EndTable.seat_id + 1 AND MiddleTable.seat_status  = '占' THEN 1
			 
					--走査中座席が始点座席と終点座席の間にあり、かつ空席である
				 	WHEN MiddleTable.seat_id BETWEEN StartTable.seat_id AND EndTable.seat_id AND MiddleTable.seat_status = '空' THEN 1 
			 
					--上記条件群を満たしていない座席があった場合、取得条件から外れる
					ELSE 0 END 
		 )
;

/*出力
空席シーケンスビュー(SeatView)
 start_seat | end_seat | vacancy_number
------------+----------+----------------
          2 |        5 |              4
          7 |        7 |              1
          9 |       10 |              2

空席シーケンスビューの中で最大連続空席数を持つレコードを表示する*/	

--取得値
SELECT
	--始点の座席番号
	start_seat,
	
	--区切り文字
	'～',
	
	--終点の座席番号
	end_seat,
	
	--連続空席数
	vacancy_number
--参照範囲	
FROM
	--上記で作成した空席シーケンスビュー
	SeatView	
--取得条件
WHERE
	-- 連続空席数がビュー内で最大
	vacancy_number = 
	
		--最大連続空席数を求めるサブクエリ
		(
			--取得値
			SELECT
				--最大連続空席数
				 MAX(vacancy_number)
			--参照範囲
			FROM 
				--空席シーケンスビュー
				SeatView
		)
;

/*出力
 start_seat | ?column? | end_seat | vacancy_number
------------+----------+----------+----------------
          2 | ～       |        5 |              4
*/
