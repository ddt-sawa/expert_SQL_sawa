/* 演習1-3 ORDER BYでソート列を作る
 最後に考えてもらう問題は、ちょっと小手先のテクニックに属するものですが、
 時として使う必要に迫られることがあるので紹介しておきます。
 演習問題1-1で利用したGreatestsテーブルに対して、普通に
 「SELECT key FROM Greatests ORDER BY key;」というクエリを実行すると、
 key列をアルファベット順にソートした形で結果が表示されます。
 では問題です。その表示結果を、「B-A-D-C」の順に並び替えるクエリを考えてください。
 この順番に特に規則性はありません。できたら他の順番でも試してみてください。*/
 
--選択列
SELECT
 
	--キー列
	key,
	
	--x
	x,
	
	--y
	y,
	
	--z
	z
	
--選択範囲
FROM

	--最大値取得用テーブル
	Greatests
	
--ソート
ORDER BY

	--ソート順を指定するための条件分岐
	CASE
	
		--Bを先頭
		WHEN key = 'B' THEN 1
		
		--次にA
		WHEN key = 'A' THEN 2
		
		--次にD
		WHEN key = 'D' THEN 3
		
		--最後にC
		WHEN key = 'C' THEN 4
		
		--例外処理を行い
		ELSE NULL
		
	 --上記の順番に並び替える
	 END 
;
