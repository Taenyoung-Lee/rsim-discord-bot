# Filename: discord_alarm.R (Universal Final Version in English)

suppressPackageStartupMessages({
  if (!require("httr", quiet = TRUE)) install.packages("httr", quiet = TRUE)
  if (!require("openssl", quiet = TRUE)) install.packages("openssl", quiet = TRUE)
  if (!require("rstudioapi", quiet = TRUE)) install.packages("rstudioapi", quiet = TRUE)
  library(httr)
  library(openssl)
  library(rstudioapi)
})

.encrypted_text_b64 <- ""

.xor_cipher <- function(data, key) {
  key_long <- rep(key, length.out = length(data))
  xor(data, key_long)
}

# --- Detect environment and prompt for password ---
.password_input <- if (rstudioapi::isAvailable()) {
  # RStudio environment: Use graphical pop-up
  askForPassword("Enter password to ready alarm    (hint - birth)")
} else {
  # Terminal environment (Linux, WSL, VSCode, etc.): Use getPass
  if (!require("getPass", quiet = TRUE)) install.packages("getPass", quiet = TRUE)
  getPass::getPass("Enter password to ready alarm    (hint - birth)")
}

.decrypted_webhook_url <- tryCatch({
  .key_raw <- charToRaw(.password_input)
  .encrypted_raw <- base64_decode(.encrypted_text_b64)
  .decrypted_raw <- .xor_cipher(.encrypted_raw, .key_raw)
  rawToChar(.decrypted_raw)
}, error = function(e) { return(NULL) })

if (is.null(.decrypted_webhook_url) || !startsWith(.decrypted_webhook_url, "http")) {
  stop("ERROR: Invalid password or corrupted data.")
} else {
  cat("SUCCESS: Password verified. The `send_alarm()` function is now loaded.\n
Call `send_alarm(TRUE)` at the end of your script to send a notification.\n")
}

send_alarm <- function(send_it = TRUE, msg = "Task completed!") {
  if (send_it == TRUE) {
    current_time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    full_message <- paste(msg, "(", current_time, ")")
    message_body <- list(username = "R Bot", content = full_message)
    
    tryCatch({
      response <- POST(url = .decrypted_webhook_url, body = message_body, encode = "json")
      if (status_code(response) >= 200 && status_code(response) < 300) {
        cat("SUCCESS: Notification sent.\n")
      } else {
        cat("ERROR: The Discord server returned an error. (Status code:", status_code(response), ")\n")
        cat("   -> Server response:", content(response, "text", encoding = "UTF-8"), "\n")
      }
    }, error = function(e) {
      cat("ERROR: Network connection failed.\n")
      cat("   -> Details:", e$message, "\n")
    })
  } else {
    cat("INFO: Notification sending was disabled.\n")
  }
}

rm(.encrypted_text_b64, .xor_cipher, .password_input)