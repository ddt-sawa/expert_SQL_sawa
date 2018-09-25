/*演習4-2 特性関数の練習
 本文中のStudentsテーブルを使って、特性関数の練習を少しやっておきましょう。
それでは、「全員が9月中に提出済みの学部」を選択するSQLを考えてください。
答えは「経済学部」ただ一つになります。理学部は100番の学生が10月になってから
提出しているので却下、文学部と工学部はそもそも未提出の学生がいる時点でダメです。
 student_id | department_name | submit_date
------------+-----------------+-------------
 100        | 理学部          | 2005-10-10
 101        | 理学部          | 2005-09-22
 102        | 文学部          |
 103        | 文学部          | 2005-09-10
 200        | 文学部          | 2005-09-22
 201        | 工学部          |
 202        | 経済学部        | 2005-09-25
 */

--取得値
SELECT

	--学部名
	DEPARTMENT_NAME
	
--参照範囲
FROM

	--学生テーブル
	StudentsTable
	
--グループ化のキー列	
GROUP BY 

	--学部名
	DEPARTMENT_NAME
	
--取得する集合の条件
HAVING

	--レコード行数と条件を満たす要素の合計が等しい
	COUNT(*) = SUM( 
	
					--条件を満たす要素を探索する特性関数
					CASE 
						
						--2005年10月以前に提出した場合条件を満たす
						WHEN SUBMIT_DATE < '2005-10-01' THEN 1 
						
						--そうでない場合条件を満たさない
						ELSE 0 END)
;