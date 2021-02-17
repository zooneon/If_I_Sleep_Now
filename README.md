![180](https://user-images.githubusercontent.com/59433441/108235549-42cb2580-7189-11eb-92af-34d5129624b0.jpg)
# 지금자면
## 🚀 Link
🖋 [Notion](https://www.notion.so/zzooneon/6632e475a1e24e21ba27f324d981e81e) 
<br/>
🖌   [Prototype](https://www.figma.com/file/mfBOZfGSjmmG66m82JGzXM/I2SN-prototype?node-id=0%3A1) 
<br/>
<br/>
## 💥 About
### Subject
일어날 시간을 정하고 기상 시간까지 얼마나 잘 수 있는지 알림을 통해 알려주는 시스템
<br/>
### Develop Environment
- Xcode 12.4
- Swift 5.0
### iOS Deployment Target
- iOS 13.0+
## ⚒ Features
<img src="https://user-images.githubusercontent.com/59433441/108239960-bbcc7c00-718d-11eb-84d3-e8dc0dc6cdd6.png"
  width="200"
  height="420">
> datepicker를 보여주고 이를 이용하여 기상 시간을 설정한다.<br/>
시작 버튼을 누르면 기상 시간까지 몇 시간 남았는지 알려주는 알림 기능이 활성화된다.<br/>
시작 버튼을 누르면 pickerview는 사라지고 잔여시간(시간, 분, 초)을 알려주는 label이 나타난다.<br/>
시작 버튼은 취소 버튼으로 변경되고 취소 버튼을 누르면 기존의 알림 기능은 취소되고 다시 pickerview로 돌아간다.
<br/>
<img src="https://user-images.githubusercontent.com/59433441/108240924-a86de080-718e-11eb-9503-aac1956cd2b2.png"
  width="200"
  height="420">
  
> 알림 받을 시간 간격을 10분, 30분, 1시간 중 선택할 수 있다.<br/>
선택된 시간은 UserDefaults를 이용하여 저장하고, 필요할 때마다 가져와서 사용한다.<br/>
알람음 선택을 탭하면 view를 이동한다.<br/>
<br/>
<img src="https://user-images.githubusercontent.com/59433441/108241266-ff73b580-718e-11eb-8ebc-e65fc0a9bf36.png"
  width="200"
  height="420">

> 알람음을 선택할 수 있다.<br/>
선택된 알람음은 UserDefaults를 이용하여 저장한다.

<img src="https://user-images.githubusercontent.com/59433441/108241400-2631ec00-718f-11eb-8929-f83eba7b9e5e.png"
  width="200"
  height="420">

> 알림은 배너, 잠금화면에 나타나며 설정에서 변경할 수 있다.
소리나 진동은 울리지 않는다.

<img src="https://user-images.githubusercontent.com/59433441/108241815-950f4500-718f-11eb-93d8-6b9d9735f718.png"
  width="200"
  height="420">

> 알람은 30초 동안 울리며 그만 버튼을 누르면 종료된다.
