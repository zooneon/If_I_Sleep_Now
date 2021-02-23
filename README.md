<img align="left" width="120" height="120" src="https://user-images.githubusercontent.com/59433441/108235549-42cb2580-7189-11eb-92af-34d5129624b0.jpg" alt="icon">

# 지금자면
> ⏰ 남은 수면시간 알림 서비스
<br/>
<div display="flex">
  <img width="180" height="380" src="https://user-images.githubusercontent.com/59433441/108804046-94d3d700-75df-11eb-82a5-6b37c488630a.png" alt="01.png">
  <img width="180" height="380" src="https://user-images.githubusercontent.com/59433441/108804165-d6fd1880-75df-11eb-9b68-28bfe65e5864.png" alt="02.png">
  <img width="370" height="380" src="https://user-images.githubusercontent.com/59433441/108804426-9c47b000-75e0-11eb-8c9b-5d21ab95d067.png" alt="03.png">
</div>

## 🚀 Link
### [Notion](https://www.notion.so/zzooneon/6632e475a1e24e21ba27f324d981e81e)
### [Prototype](https://www.figma.com/file/mfBOZfGSjmmG66m82JGzXM/I2SN-prototype?node-id=0%3A1)
### [App Store](https://apps.apple.com/kr/app/%EC%A7%80%EA%B8%88%EC%9E%90%EB%A9%B4/id1554865312)
<br/>

## ✨ About
### Develop Environment
- Xcode 12.4
- Swift 5.0
### iOS Deployment Target
- iOS 13.0+
<br/>

## ⚒ Features

<img src="https://github.com/19-47/If_I_Sleep_Now/blob/develop/images/home.gif"
  width="200"
  height="420">
<br/>

**Main**
- 시작 버튼을 누르면 기상 시간까지 얼마나 남았는지 알려주는 알림 기능이 활성화된다.
- 시작 버튼을 누르면 잔여시간(시간 : 분 : 초)이 나타난다.
- 그만 버튼을 누르면 기존의 알림 기능은 취소된다.
<br/>

<img src="https://github.com/19-47/If_I_Sleep_Now/blob/develop/images/setting.gif"
  width="200"
  height="420">
<br/>

**Setting**
- 알림 받을 시간 간격을 10분, 30분, 1시간 중 선택할 수 있다.
- 선택된 시간은 UserDefaults를 이용하여 저장하고, 필요할 때마다 가져와서 사용한다.
<br/>

<img src="https://github.com/19-47/If_I_Sleep_Now/blob/develop/images/sound.gif"
  width="200"
  height="420">
<br/>

**Sound setting**
- 알람음을 선택할 수 있다.
- 선택된 알람음은 UserDefaults를 이용하여 저장한다.
<br/>

<img src="https://github.com/19-47/If_I_Sleep_Now/blob/develop/images/notification.gif"
  width="200"
  height="420">
<br/>

**Notification**
- 알림은 배너, 잠금화면에 나타나며 설정에서 변경할 수 있다.
- 알림은 총 6번만 나타난다.
- 소리나 진동은 울리지 않는다.
<br/>

<img src="https://github.com/19-47/If_I_Sleep_Now/blob/develop/images/alarm.gif"
  width="200"
  height="420">
<br/>

**Alarm**
- 알람은 30초 동안 울리며 그만 버튼을 누르면 종료된다.
