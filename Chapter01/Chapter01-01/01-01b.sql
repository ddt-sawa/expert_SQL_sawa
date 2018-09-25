/* 演習1-1 複数列の最大値
SQLでは、複数行の中から最大値/最小値を選ぶことは簡単です。適当なキーで
GROUPBY句で集約し、MAX/MIN関数を使えばよいだけです。では、複数列の中から
最大値を選ぶにはどうすればよいでしょう。
サンプルデータは以下のものを使いましょう。
Greatests
 key | x | y | z
-----+---+---+---
 A   | 1 | 2 | 3
 B   | 5 | 5 | 2
 C   | 4 | 7 | 1
 D   | 3 | 3 | 8
 
b.レコード内のx,ｙ,zにおける最大値を取得*/ 

--取得列
SELECT 
	
	--キー値
	key,
	
	--最大値を取得する条件分岐
	CASE WHEN 
	
		--xとyの内大きいほうを仮最大値として、	
		(CASE WHEN x > y THEN x ELSE Y END)
			
		--仮最大値よりzの方が大きい場合zが最大値
		 < Z THEN Z
	 
		
	--zが最大値でない場合
	ELSE
	
		--xとyの内大きいほうが最大値
		CASE WHEN x > y THEN x ELSE y END
			
			
	--最大値を出力
	END AS greatest

--参照範囲
FROM

	--最大値取得用テーブル
	Greatests
;
