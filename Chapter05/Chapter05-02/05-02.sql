/*演習5-2 子供の数にご用心

使用するテーブルとビュー

社員テーブル(PersonnelTable)
 employee_name | first_children | second_children | third_children
---------------+----------------+-----------------+----------------
 赤井          | 一郎           | 二郎            | 三郎
 工藤          | 春子           | 夏子            |
 鈴木          | 夏子           |                 |
 吉田          |                |                 |

子供ビュー(ChildrenView)
 child_name
------------
 春子
 三郎
 夏子
 一郎
 二郎
(5 行)

「外部結合で行列変換 その2(列→行):繰り返し項目を1列にまとめる」(p.85)では、
社員ごとの子供の一覧を求めました。こういうリストが得られれば、一人の社員が
何人の子供を扶養しているか、という情報も、社員単位で集約することで簡単に
求められます。では、本文のクエリを修正して、これを求めてください。
求める結果は次のようになります。

 employee_name | count
---------------+-------
 吉田          |     0
 工藤          |     2
 赤井          |     3
 鈴木          |     1	

 多分、基本的には悩むことはないと思いますが、微妙に注意が必要なポイントがあるので
自分が書いたコードの結果と上の答えをよく見比べてみてください。*/

--取得値
SELECT 

	--社員名
	TemporaryTable.employee_name,
	
	--社員単位の子供数
	Count(TemporaryTable.child_name) AS children_number

--参照範囲
FROM
	--子供
	(
		--取得値
		SELECT 
	
			--社員名
			PersonnelTable.employee_name,
		
			--子供名
			ChildrenView.child_name
	
		--参照範囲
		FROM
	
			--社員テーブル
			PersonnelTable
		
		
		--子供がNULLになる社員が存在すると考えられるので、左外部結合	
		LEFT OUTER JOIN
	
			--子供ビュー
			ChildrenView
		
		--結合列
		ON
	
			--子供の名前が社員テーブルの子供欄のいずれかに存在した場合結合
			ChildrenView.child_name IN (PersonnelTable.first_children, PersonnelTable.second_children,PersonnelTable.third_children)
		
	) AS TemporaryTable
	
--社員単位の集約を行う
GROUP BY

	--社員
	TemporaryTable.employee_name
;
	
