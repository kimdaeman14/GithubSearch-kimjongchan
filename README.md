# GithubSearch-kimjongchan

![Jan-24-2020 13-19-26](https://user-images.githubusercontent.com/34432988/73044306-69e2f500-3eac-11ea-992c-8f96563baeea.gif)
![Jan-24-2020 13-19-52](https://user-images.githubusercontent.com/34432988/73044305-69e2f500-3eac-11ea-92d9-50683ec46664.gif)

- 소개: GithubAPI를 이용해서 데이터를 보여주는 앱 입니다. 
- 요구사항: 

- 1. Github API사용 
(https://developer.github.com/v3/search/#search-users, https://developer.github.com/v3/users/#get-a-single-user)- 
- 2. Github SearchBar
SearchBar 에 텍스트를 입력할 때 마다 User를 검색한다(0.5초 Debounce)
- 3. UI 구성 
User 의 프로필 이미지, 이름, Public Repo 갯수를 표시한다
검색 전 / 후의 Empty 상태에 대한 UI는 자유롭게 구현
- 4. Pagination
Loadmore 상태일 때 Indicator를 보여준다
더 이상 불러올 User가 없을 땐 indicator가 보여지면 안된다

- 역할: iOS 어플리케이션 100%담당
- 관련기술: Swift, MVC, OnlyCode, Snapkit, SwiftyJSON, Then, Alamofire, Kingfisher
