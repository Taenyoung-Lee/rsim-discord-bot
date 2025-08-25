# 1. ★ 여기만 자신의 정보로 수정하세요 ★
my_password          <- ""      # 사용할 비밀번호
webhook_url_original <- "" # 실제 웹훅 주소
# ------------------------------------

#' XOR 방식으로 암호화/복호화하는 함수
#' @param data 원본 데이터 (raw 벡터)
#' @param key 키 (raw 벡터)
#' @return 암호화 또는 복호화된 데이터 (raw 벡터)
xor_cipher <- function(data, key) {
  # 키를 데이터 길이에 맞게 반복해서 늘려줍니다.
  key_long <- rep(key, length.out = length(data))
  # XOR 연산을 수행합니다.
  xor(data, key_long)
}

cat("--- XOR 방식으로 암호화 및 자체 검증을 시작합니다 ---\n\n")

# 2. 암호화 수행
original_raw <- charToRaw(webhook_url_original)
key_raw      <- charToRaw(my_password)
encrypted_raw <- xor_cipher(original_raw, key_raw)

# 3. 즉시 복호화 테스트 수행
decrypted_raw_test <- xor_cipher(encrypted_raw, key_raw)

# 4. 최종 결과 출력 및 검증
cat("1. 생성된 암호문 (Base64 인코딩):\n")
# 텍스트로 안전하게 변환하기 위해 base64 인코딩을 사용합니다.
# openssl 패키지는 이 용도로만 잠시 사용합니다.
if (!require("openssl", quiet = TRUE)) install.packages("openssl", quiet = TRUE)
encrypted_text_b64 <- openssl::base64_encode(encrypted_raw)
print(encrypted_text_b64)
cat("\n--------------------------------------------------------\n\n")

cat("2. 자체 복호화 테스트 결과:\n")
if (identical(original_raw, decrypted_raw_test)) {
  cat("✅ [성공] 가장 단순한 XOR 방식 테스트를 통과했습니다. 이 암호문을 사용하세요.\n")
} else {
  cat("❌ [실패] R 기본 연산에 문제가 있습니다. R 자체를 재설치해야 할 수 있습니다.\n")
}