# happbit
## 프로젝트 소개
> 나만의 습관 형성 기록, 햇빛 <br>
좋은 습관을 형성하고 싶은 분들을 위한 작심삼일 타파 서비스입니다. <br>

- 프로젝트 기간 : 2024.09.18 ~ 2024.10.01 <br>
- 개발 인원 : iOS 1인
- [앱스토어](https://apps.apple.com/kr/app/happbit-%EB%82%98%EB%A7%8C%EC%9D%98-%EC%8A%B5%EA%B4%80-%ED%98%95%EC%84%B1-%ED%96%87%EB%B9%9B/id6711330927) <br>

## 개발 환경
`swift 5.10` `Xcode 15.4` `iOS 16.0+`<br>
`다크모드 지원`

## 기술 스택
`SwiftUI` `MVVM` <br>
`Realm` -> `CoreData`<br>
`Combine`

## 핵심 기능
|홈|습관 추가|자리잡은 습관|중단한 습관|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/5b59cc31-0ae5-42db-aa1d-4ecb7002c0bc"/>|<img src="https://github.com/user-attachments/assets/d1b328bf-bff8-4595-86d3-b812668e8a06">|<img src="https://github.com/user-attachments/assets/5577b6c0-c146-4f49-b3b7-7125e1ec1226"/>|<img src="https://github.com/user-attachments/assets/fd38d3ee-fc0b-4353-b641-f475dfc658e6"/>|

## 주요 기술
1. MVVM + In/Output 패턴에 Action 접목
2. Combine을 통한 반응형 프로그래밍
3. 특정 시간 push 알림 (예정)
4. 당일 실천 현황 확인 가능한 위젯 (예정)

## 트러블 슈팅
- Realm 데이터 삭제 시 fetal error 발생
- 실천 현황 처리 로직에 대한 어려움
