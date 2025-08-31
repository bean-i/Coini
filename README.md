# 🪙 Coini  
- **開発期間**: 2025年3月（約1週間）  
- **開発形態**: 個人開発  

## ✅ 主な機能  
**1. 取引所レート表示**  
主要コインのレートを**5秒間隔で自動更新**し、**基準に応じた並び替え**が可能  

**2. コイン情報**  
**トレンドコイン・NFTを10分間隔で更新**、シンボル／名前で検索可能  

**3. お気に入り管理**  
コインの**お気に入り登録／解除**、お気に入りリストとして保持  

## 💻 技術スタック  
- **言語**: `Swift`  
- **フレームワーク**: `UIKit`  
- **アーキテクチャ**: `MVVM (Input/Output パターン)`  
- **非同期処理**: `RxSwift`, `RxCocoa`  
- **ネットワーク**: `Alamofire`  
- **データベース**: `Realm`  
- **UIレイアウト／画像処理**: `SnapKit`, `Kingfisher`  

## 🔎 工夫した点  
### 1. 実時間データ更新の制御  
- 取引所画面は**5秒ごと**、コイン情報画面は**10分ごと**に更新  
- ネットワーク接続状態を反映した **条件付きポーリング** を実装  
- ネットワーク呼び出しは RxSwift の **Single** でラップし、**成功／失敗を明確化**  
- 失敗時は**空データを返却**し、**ストリームが途切れないように設計**  

### 2. メモリ管理とUI更新の安定化  
- RxSwift 購読で**弱参照＋DisposeBag**を活用し、**循環参照／メモリリークを防止**  
- セルごとに **DisposeBag** を持たせ、**再利用時に購読が自動的に解放**されるように構成  
- `distinctUntilChanged` を適用し、**意味のある値変化時のみ UI 更新**（不要な再描画を**抑制**）  
- ネットワーク応答は**バックグラウンドスレッドで加工後**、**安定した更新を保証するため** UIは **MainSchedulerで反映**  

### 3. お気に入り機能の永続化設計  
- **Realm** でお気に入り状態を保存し、**再起動／オフラインでも維持**  
- **Repository パターン**でデータ層を抽象化し、**ViewModel との結合度を低減**  

## 📷 画面  
| 取引所 | コイン情報 | 検索 | 詳細 |
|:--:|:--:|:--:|:--:|
| <img alt="거래소" src="https://github.com/user-attachments/assets/2a8d6cce-c110-41c0-a33f-a2fb76ea61ce" /> | <img alt="인기 탭" src="https://github.com/user-attachments/assets/1e15761a-33c4-40af-9da7-af1724f7e885" /> | <img alt="검색" src="https://github.com/user-attachments/assets/2bfebade-ca94-411b-973c-8c46a9f79f9e" /> | <img alt="상세" src="https://github.com/user-attachments/assets/acdfbdd6-9a96-454a-ba23-fbfd823ecefc" /> |
