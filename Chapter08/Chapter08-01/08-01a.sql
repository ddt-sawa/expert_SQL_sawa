/*演習8-1 配列テーブル--行持ちの場合
「列に対する量化：オール1の行を探せ」では、疑似配列テーブルで列方向の量化を
行う方法を考えました。演習では、このテーブルをちゃんと行持ちの形式に直した
テーブルを使いましょう。「i」列が配列の添え字を表しますから、主キーは(key,i)です。

配列テーブル(ArrayTable)
 array_code | array_index | array_value
------------+-------------+-------------
 A          |           1 |
 A          |           2 |
 A          |           3 |
 A          |           4 |
 A          |           5 |
 A          |           6 |
 A          |           7 |
 A          |           8 |
 A          |           9 |
 A          |          10 |
 B          |           1 |           3
 B          |           2 |
 B          |           3 |
 B          |           4 |
 B          |           5 |
 B          |           6 |
 B          |           7 |
 B          |           8 |
 B          |           9 |
 B          |          10 |
 C          |           1 |           1
 C          |           2 |           1
 C          |           3 |           1
 C          |           4 |           1
 C          |           5 |           1
 C          |           6 |           1
 C          |           7 |           1
 C          |           8 |           1
 C          |           9 |           1
 C          |          10 |           1
 D          |           2 |
 D          |           3 |           9
 D          |           4 |
 D          |           5 |
 D          |           6 |
 D          |           7 |
 D          |           8 |
 D          |           9 |
 D          |          10 |
 D          |           1 |
 E          |           1 |
 E          |           2 |           3
 E          |           3 |
 E          |           4 |           1
 E          |           5 |           9
 E          |           6 |
 E          |           7 |
 E          |           8 |           9
 E          |           9 |
 E          |          10 |
 
それでは、このテーブルから「オール1」のエンティティだけを選択してください。
答えはC一つだけになります。今度は行方向への全称量化なので、EXISTSを使います。
厳密に考えると、この問題は中々トリッキーです。その罠の存在に気づいたら上級者です。
もしEXISTSを使って解けたら、別解も考えてみてください。
非常に多彩な別解が存在して。面白いですから。

a.EXISTSによる解法*/


--エンティティ名のみを重複なしで取得する
SELECT DISTINCT

	--要素がオール1の配列名
	array_code

--参照範囲	
FROM

	--配列テーブル
	ArrayTable AS MasterTable

--取得条件
WHERE

	--エンティティ内に1以外の要素が存在しない
	NOT EXISTS
	
	--1以外の要素が存在しないエンティティを調べるサブクエリ
	(
		--取得値
		SELECT 
		
			--全列
			*
		
		--参照範囲	
		FROM
		
			--サブクエリ内配列テーブル
			ArrayTable AS QueryTable
			
		--取得条件
		WHERE
		
			--自身と同じエンティティ名
			QueryTable.array_code = MasterTable.array_code
		
			
		--に1以外の要素が存在しない
		AND
			
			--全要素が1ではない
			(QueryTable.array_value <> 1
				 
			--または
			OR
				
			--全要素がNULL(3値論理の関係上、上記だけではサブクエリの返却値がunknownになってしまうため、全要素がNULLの場合もtureとして返却する)
			QueryTable.array_value IS NULL)
	)
;