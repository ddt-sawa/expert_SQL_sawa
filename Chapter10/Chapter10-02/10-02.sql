/*演習10-2 行によって条件が異なる特性関数
CASE式による特性関数とHAVING句を組み合わせる技術をもう少し練習しておきましょう。
ちょっと難易度の高い問題を出します。サンプルには、「EXISTS述語の使い方」でも使った
次のようなテスト結果を保存するテーブルを使います。

成績テーブル(score_table)
 student_id | subject_name | score_value
------------+--------------+-------------
        100 | 算数         |         100
        100 | 国語         |          80
        100 | 理科         |          80
        200 | 算数         |          80
        200 | 国語         |          95
        300 | 算数         |          40
        300 | 国語         |          90
        300 | 社会         |          55
        400 | 算数         |          80

一人の学生につき複数の教科の結果を保存しています。「EXISTS述語の使い方」では、
ここから次の条件をともに満たす学生を選択するクエリを、述語論理的な発想によって考えました。
1.算数の点数が80点以上
2.国語の点数が50点以上
結果は、100番と200番の学生になります。400番のように「国語」のデータが存在しない
学生は対象外とします。これをHAVING句と特性関数を使って解いてください。*/

--取得値
SELECT 
	--学生ID
	student_id
--参照範囲
FROM
	--成績テーブル
	score_table
--取得条件
WHERE
	--社会の点数について考慮しないので除外
	subject_name IN ('算数','国語')
--部分集合のキー
GROUP BY
	--学生ごとに部分集合を作成する
	student_id
--部分集合に対する条件
HAVING
	--算数・国語のデータが存在する 
	COUNT(*) = 2
--かつ
AND
	--算数の点数が80点以上
	SUM(
		--参照中の科目が算数の場合
		CASE WHEN subject_name = '算数' THEN 
	
			--80点以上ならば条件を満たす
			CASE WHEN score_value >= 80 THEN 1  
					
			--80点未満なら条件を満たさない
			ELSE 0 END
					
		--参照中教科が算数でない場合、条件と関係ないので放置
		ELSE 0 END
		
		--算数の点数が80点以上の場合、算数の制限はクリア
		) = 1
	
--かつ
AND
	--国語の点数が50点以上
	SUM(
		--参照中の科目が国語の場合
		CASE WHEN subject_name = '国語' THEN 
	
			--50点以上ならば条件を満たす
			CASE WHEN score_value >= 50 THEN 1  
					
			--50点未満なら条件を満たさない
			ELSE 0 END
					
		--参照中教科が国語でない場合、条件と関係ないので放置
		ELSE 0 END
		
		--国語の点数が50点以上の場合、国語の制限はクリア
		) = 1
;
/*出力
 student_id
------------
        100
        200
/*
