/*演習8-2 ALL述語による全称量化
 
使用テーブル

工程テーブル(ProjectTable)
 project_id | step_number | project_status
------------+-------------+----------------
 AA100      |           0 | 完了
 AA100      |           1 | 待機
 AA100      |           2 | 待機
 B200       |           0 | 待機
 B200       |           1 | 待機
 CS300      |           0 | 完了
 CS300      |           1 | 完了
 CS300      |           2 | 待機
 CS300      |           3 | 待機
 DY400      |           0 | 完了
 DY400      |           1 | 完了
 DY400      |           2 | 完了

全称量化は、NOT EXISTSだけではなく、ALL述語によっても書くことが出来ます。
ALL述語は、二重否定を使わなくてもよいため、SQLが分かりやすくなるのが利点です。
では、「全称量化 その2:集合 VS 述語--凄いのはどっちだ?」のクエリを、
ALL述語で書き換えてみてください。*/

--取得値
SELECT DISTINCT

	--工程が1番までしか終わっていない作業名
	MasterTable.project_id

--参照範囲	
FROM

	--工程テーブル
	ProjectTable AS MasterTable
	
--工程が1番までしか終わっていない作業の取得条件
WHERE 

	--1番までの工程の状態が全部'完了'である
	'完了' = ALL
	
		--1番までの工程の状態を取得するサブクエリ
		(
	
			--取得値
			SELECT 
			
				--工程状態
				QueryTable.project_status 
			
			--参照範囲	
			FROM 
			
				--工程テーブル
				ProjectTable AS QueryTable 
			
			--取得条件	
			WHERE 
			
				--検討中の作業において、1番以下の工程
				MasterTable.project_id = QueryTable.project_id AND QueryTable.step_number <= 1 
				
		)

--取得条件その2	
AND

	--2番以降の工程の状態が全部'待機'である
	'待機' = ALL
	
		--2番以降の工程の状態を取得するサブクエリ
		(
	
			--取得値
			SELECT 
			
				--工程状態
				QueryTable.project_status 
			
			--参照範囲	
			FROM 
			
				--工程テーブル
				ProjectTable AS QueryTable 
			
			--取得条件	
			WHERE 
			
				--検討中の作業において、2番以上の工程
				MasterTable.project_id = QueryTable.project_id AND QueryTable.step_number >= 2 
				
		)

;
