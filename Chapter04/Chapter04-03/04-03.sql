/*演習4-3 バスケット解析の一般化
「関係除算でバスケット解析」(p.73)では、条件を満たす店舗だけを結果として選択しました。
しかし、要件によっては品物をすべてそろえていなかった店舗についても「どれくらいの品物が不足していたのか」
を一覧表示したいこともあるでしょう。
そこで、先の関係除算のクエリを、次のように全店舗について結果を一覧表示するよう変更してください。
my_item_cntは店舗の現在在庫数、diff_cntは足りなかった商品の数を表します。

商品テーブル
 item_name
-----------
 ビール
 紙オムツ
 自転車

店舗テーブル
 shop_name | item_name
-----------+-----------
 仙台      | ビール
 仙台      | 紙オムツ
 仙台      | 自転車
 仙台      | カーテン
 東京      | ビール
 東京      | 紙オムツ
 東京      | 自転車
 大阪      | テレビ
 大阪      | 紙オムツ
 大阪      | 自転車
*/

--取得値
SELECT

	--店舗名
	SHOP_NAME,
	
	--店舗テーブルと商品テーブルで等しい商品名があった場合カウントを行い、その合計を充足商品数とする
	SUM(CASE WHEN ShopTable.ITEM_NAME = JoinningTable.ITEM_NAME THEN 1 ELSE 0 END ) AS MY_ITEM_COUNT,
	
	--商品テーブルの商品数から充足商品数を引いた値を不足商品数とする
	(SELECT COUNT(*) from ItemTable) - SUM( CASE WHEN ShopTable.ITEM_NAME = JoinningTable.ITEM_NAME THEN 1 ELSE 0 END ) AS DIFFERENT_COUNT

--参照範囲
FROM 

	--店舗テーブル
	ShopTable
	
--両テーブルの商品数を比較するため、店舗テーブルと商品テーブルの左外部結合を行う
LEFT OUTER JOIN
	
	--商品テーブル
	ItemTable AS JoinningTable 
	
--結合列
ON

	--商品名
	ShopTable.ITEM_NAME = JoinningTable.ITEM_NAME
	
--店舗ごとに集合化
GROUP BY

	--店舗名
	SHOP_NAME
;
