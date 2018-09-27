/*演習7-2 厳密な関係除算
「3.差集合で関係除算を表現する」(p.129)で、除算を減算に還元して解く方法を紹介しました。
そのクエリを「厳密な除算」をするよう修正してください。(「厳密な除算」の定義、覚えていますか?)
今度は過不足なくスキルを満たす社員だけを選択するので、結果は神崎氏ひとりになります。

使用するテーブル

スキルテーブル(SkillTable)
 skill_name
------------
 Oracle
 UNIX
 Java

社員テーブル(EmployeeTable)
 employee_name | skill_name
---------------+------------
 相田          | Oracle
 相田          | UNIX
 相田          | Java
 相田          | C#
 神崎          | Oracle
 神崎          | UNIX
 神崎          | Java
 平井          | UNIX
 平井          | Oracle
 平井          | PHP
 平井          | Perl
 平井          | C++
 若田部        | Perl
 渡来          | Oracle
*/


--取得値
SELECT

	--社員名
	FirstEmployeeTable.employee_name

--参照範囲	
FROM

	--社員テーブル
	EmployeeTable AS FirstEmployeeTable

--取得条件	
WHERE

	--スキルテーブルの項目から社員の保有スキルを除算していき、空集合になった場合
	NOT EXISTS
	
	--除算を行うサブクエリ
		(
		
			--取得値
			SELECT

				--スキル名
				SkillTable.skill_name
							
			--参照範囲
			FROM
				
				--スキルテーブル
				SkillTable
				
		--ある社員の保有スキルを上記集合から除算する
		EXCEPT
		
			--取得値
			SELECT

				--保有スキル名
				SecondEmployeeTable.skill_name
							
			--参照範囲
			FROM
				
				--社員テーブル
				EmployeeTable AS SecondEmployeeTable
				
		--取得条件
		WHERE
		
			--ある特定の社員について
			SecondEmployeeTable.employee_name = FirstEmployeeTable.employee_name
				
		)

--スキルテーブルの項目数と社員の保有スキル数が等しいかを調べるため、社員ごとにグループ化	
GROUP BY 


	--社員名
	FirstEmployeeTable.employee_name
	

--厳密な除算(相等性)を確保するための取得条件
HAVING 	

	--スキルテーブルの項目数と社員の保有スキル数が等しい
	(SELECT COUNT(*) FROM SkillTable) = Count(FirstEmployeeTable.employee_name)
;

