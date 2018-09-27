/*演習6-2 あまり知られていませんが、SQL-92には、まさに期間の重複を調べるための
OVERLAPSなる述語が存在しています。(OracleやPostgreSQLが実装しています)。
この述語は、次のように使います。

(開始日付1,終了日付1) OVERLAPS(開始日付2,終了日付2)

では、これを使って、「オーバーラップする期間を調べる」(p.117)クエリを書き換えて、
結果を確認してみてください。実は、BETWEENを使った場合とOVERLAPSを使った場合では、
微妙に結果が異なるのです。それを理解してもらうのがこの演習の目的です。*/

--取得値
SELECT

	--宿泊者
	MasterTable.reserver_name,
	
	--投宿日
	MasterTable.start_date,
	
	--出発日
	MasterTable.end_date
	
--参照範囲
FROM

	--宿泊テーブル
	ReservationTable AS MasterTable
	
--取得条件
WHERE

	--他の宿泊客とのオーバーラップが存在する
	EXISTS 
	
	--オーバーラップしているかどうかを調べるサブクエリ
	(
	
		--取得値
		SELECT
		
			--全列
			*
			
		--参照範囲
		FROM
		
			--宿泊テーブル
			ReservationTable AS DataTable
			
		--取得範囲
		WHERE
		
			--自分以外の宿泊客
			MasterTable.reserver_name <> DataTable.reserver_name
		
		--かつ	
		AND 

			--宿泊期間のオーバーラップが発生している
			(MasterTable.start_date,MasterTable.end_date) OVERLAPS (DataTable.start_date, DataTable.end_date)
	)
;

/*出力結果
 reserver_name | start_date |  end_date
---------------+------------+------------
 山本          | 2006-11-03 | 2006-11-04
 内田          | 2006-11-03 | 2006-11-05
 
 本文で紹介されていたBETWEEN使用時の結果と異なり、
 端点でのみオーバーラップしていた一組が取得されていない。*/
