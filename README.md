# rsim-discord-bot

# R 스크립트 완료 알리미 (Discord Webhook)

**R Discord Notifier**는 시간이 오래 걸리는 R 스크립트나 분석 작업이
완료되었을 때, Discord로 알림을 보내주는 간단하고 유용한 도구입니다. 더
이상 스크립트가 끝났는지 확인하기 위해 컴퓨터 앞을 지킬 필요가 없습니다.
☕

## ✨ 주요 특징

-   **간편한 설정**: 단 한 번의 설정으로 계속 사용할 수 있습니다.
-   **비밀번호 보호**: Discord Webhook URL을 비밀번호 기반의 간단한
    암호화(XOR)로 보호하여 코드에 그대로 노출시키지 않습니다.
-   **유연한 사용**: RStudio의 팝업창 또는 터미널 환경의 텍스트 입력
    프롬프트를 자동으로 감지하여 비밀번호를 입력받습니다.
-   **자동 패키지 설치**: `httr`, `openssl` 등 필요한 패키지를 자동으로
    설치합니다.

------------------------------------------------------------------------

## ⚙️ 작동 원리

이 도구는 두 개의 R 파일로 구성되어 있습니다.

1.  `discord_alarm_setting.R`: 사용자의 Discord Webhook 주소와
    비밀번호를 받아, 암호화된 문자열을 생성하는 **설정용
    스크립트**입니다. 이 파일은 최초 1회만 사용합니다.
2.  `discord_alarm.R`: 실제 알림을 보내는 **실행용 스크립트**입니다.
    사용자의 스크립트 시작 부분에서 이 파일을 `source()` 함수로
    로드하면, 비밀번호를 물어본 뒤 `send_alarm()` 함수를 환경에
    등록시킵니다.

------------------------------------------------------------------------

## 🚀 설치 및 사용법

### 1단계: Discord Webhook URL 준비하기

먼저 알림을 받을 Discord 서버와 채널의 Webhook URL이 필요합니다.


Discord Webhook URL 만드는 방법

1.  알림을 받고 싶은 서버 채널의 **채널 편집** 아이콘(⚙️)을 클릭합니다.
2.  왼쪽 메뉴에서 **연동** 탭으로 이동합니다.
3.  **웹후크 만들기(Create Webhook)** 버튼을 클릭합니다.
4.  생성된 웹후크의 이름을 (예: R Bot) 설정하고 **웹후크 URL 복사**
    버튼을 누릅니다. 이 URL을 잘 보관하세요.



------------------------------------------------------------------------

### 2단계: Webhook 주소 암호화하기

이제 복사한 Webhook URL을 암호화된 텍스트로 만들 차례입니다.

1.  `discord_alarm_setting.R` 파일을 엽니다.
2.  아래 두 변수에 자신의 정보를 입력합니다.
    `r     # 1. ★ 여기만 자신의 정보로 수정하세요 ★     my_password          <- "사용할_비밀번호"  # 예: "my_secret_pw"     webhook_url_original <- "위에서_복사한_웹후크_URL_붙여넣기"     # ------------------------------------`
3.  `discord_alarm_setting.R` 스크립트 전체를 실행합니다. (`Ctrl+A` -\>
    `Ctrl+Enter`)
4.  콘솔(Console) 창에 출력된 **Base64 인코딩 암호문**을 복사합니다.

------------------------------------------------------------------------

### 3단계: 알림 스크립트에 암호문 적용하기

복사한 암호문을 실제 알림 스크립트에 붙여넣습니다.

1.  `discord_alarm.R` 파일을 엽니다.
2.  상단에 있는 `.encrypted_text_b64` 변수의 값으로 **방금 복사한
    암호문**을 붙여넣습니다.
    `r     .encrypted_text_b64 <- "YOUR_ENCRYPTED_BASE64_STRING_WILL_APPEAR_HERE"`
3.  `discord_alarm.R` 파일을 저장합니다. 이제 모든 설정이 끝났습니다!

------------------------------------------------------------------------

### 4단계: 실제 스크립트에서 알림 보내기

시간이 오래 걸리는 당신의 R 스크립트에서 아래와 같이 사용하세요.

**예시 코드 (`my_analysis.R`)**

``` r
# 1. 스크립트 시작 부분에서 알림 기능을 로드합니다.
#    파일 경로를 정확하게 지정해주세요.
source("path/to/discord_alarm.R")

# -----------------------------------------------
# 2. 시간이 오래 걸리는 당신의 분석 코드
# -----------------------------------------------
print("오래 걸리는 작업을 시작합니다...")
Sys.sleep(15) # 15초 동안 대기하는 예시
print("작업이 완료되었습니다!")
# -----------------------------------------------

# 3. 모든 작업이 끝난 후 알림을 보냅니다.
send_alarm(TRUE, msg = "15초 시뮬레이션 작업 완료!")
```

-   `send_alarm()` 함수의 첫 번째 인자가 `TRUE`일 때만 알림이
    발송됩니다.
-   `msg` 파라미터로 원하는 메시지를 보낼 수 있습니다.

------------------------------------------------------------------------

## ⚠️ 보안 관련 안내

이 스크립트에 사용된 XOR 암호화는 Webhook URL을 코드에 **단순
텍스트(Plain Text)로 저장하는 것을 방지**하기 위한 최소한의 조치입니다.
이는 전문적인 암호학적 보안을 제공하지 않으므로, 민감한 정보를 다루는
용도로는 적합하지 않습니다.

------------------------------------------------------------------------

## 📦 의존성 패키지

-   `httr`
-   `openssl`
-   `rstudioapi`
-   `getPass`

(스크립트 실행 시 위 패키지들이 자동으로 설치됩니다.)



# R Script Discord Notifier

**R Discord Notifier** is a simple and useful tool that sends a Discord
notification when your long-running R scripts or analyses are complete.
No more waiting by your computer to see if your script has finished! ☕

## ✨ Features

-   **Easy Setup**: Configure it once and use it anytime.
-   **Password Protected**: Your Discord Webhook URL is protected with
    simple password-based XOR encryption to avoid exposing it in plain
    text.
-   **Flexible Usage**: Automatically detects the environment to use
    either an RStudio pop-up or a terminal prompt for password input.
-   **Auto-installs Packages**: Automatically installs required packages
    like `httr` and `openssl`.

------------------------------------------------------------------------

## ⚙️ How It Works

This tool consists of two R files:

1.  `discord_alarm_setting.R`: A **setup script** that takes your
    Discord Webhook URL and a password to generate an encrypted string.
    You only need to run this file once.
2.  `discord_alarm.R`: The **main script** that sends the notification.
    You `source()` this file at the beginning of your script, enter your
    password when prompted, and it will load the `send_alarm()` function
    into your environment.

------------------------------------------------------------------------

## 🚀 Installation and Usage

### Step 1: Get Your Discord Webhook URL

First, you need a Webhook URL from the Discord server and channel where
you want to receive notifications.


How to create a Discord Webhook URL 

1.  Click the gear icon (⚙️) to **Edit Channel** for the desired
    channel.
2.  Go to the **Integrations** tab in the left menu.
3.  Click the **Create Webhook** button.
4.  Customize the name of the webhook (e.g., R Bot) and click **Copy
    Webhook URL**. Keep this URL handy.



------------------------------------------------------------------------

### Step 2: Encrypt Your Webhook URL

Now, let's turn your Webhook URL into an encrypted string.

1.  Open the `discord_alarm_setting.R` file.
2.  Fill in your information for the two variables below:
    `r     # 1. ★ Edit only this section with your information ★     my_password          <- "your_password_here"  # e.g., "my_secret_pw"     webhook_url_original <- "paste_your_webhook_url_here"     # ------------------------------------`
3.  Run the entire `discord_alarm_setting.R` script (e.g., `Ctrl+A` -\>
    `Ctrl+Enter`).
4.  Copy the **Base64 encoded string** that is printed to the console.

------------------------------------------------------------------------

### Step 3: Configure the Notifier Script

Paste the encrypted string into the main notifier script.

1.  Open the `discord_alarm.R` file.
2.  Paste the **encrypted string you just copied** as the value for the
    `.encrypted_text_b64` variable.
    `r     .encrypted_text_b64 <- "YOUR_ENCRYPTED_BASE64_STRING_WILL_APPEAR_HERE"`
3.  Save the `discord_alarm.R` file. The setup is now complete!

------------------------------------------------------------------------

### Step 4: Use it in Your Scripts

Here is how to use the notifier in your own long-running R scripts.

**Example (`my_analysis.R`)**

``` r
# 1. Load the alarm function at the beginning of your script.
#    Make sure to provide the correct file path.
source("path/to/discord_alarm.R")

# -----------------------------------------------
# 2. Your time-consuming analysis code goes here
# -----------------------------------------------
print("Starting a long-running task...")
Sys.sleep(15) # Simulating a 15-second task
print("Task finished!")
# -----------------------------------------------

# 3. Send the notification after all tasks are complete.
send_alarm(TRUE, msg = "The 15-second simulation is complete!")
```

-   The notification is only sent if the first argument of
    `send_alarm()` is `TRUE`.
-   You can customize the notification content with the `msg` parameter.

------------------------------------------------------------------------

## ⚠️ Security Notice

The XOR encryption used in this script is a minimal measure to **avoid
storing the Webhook URL in plain text**. It is not cryptographically
secure and is not suitable for protecting highly sensitive information.
Use it for personal convenience only.

------------------------------------------------------------------------

## 📦 Dependencies

-   `httr`
-   `openssl`
-   `rstudioapi`
-   `getPass`

(These packages will be installed automatically when the script is run.)
