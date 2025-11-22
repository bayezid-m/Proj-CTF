#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUF_SIZE 8192

// Run a shell command and capture its full output
void run_command(const char *cmd, char *output) {
    FILE *fp = popen(cmd, "r");
    if (!fp) {
        strcpy(output, "");
        return;
    }

    char buffer[256];
    output[0] = '\0';
    while (fgets(buffer, sizeof(buffer), fp) != NULL) {
        strncat(output, buffer, BUF_SIZE - strlen(output) - 1);
    }
    pclose(fp);
}

int main() {
    char out_http[BUF_SIZE];
    char out_https[BUF_SIZE];
    char out_http_secret[BUF_SIZE];
    char out_https_secret[BUF_SIZE];

    int check_http_ok = 0;
    int check_https_ok = 0;
    int check_secret_ok = 0;

    const char *expected_html =
        "<p>this is unsafe http site</p><p>at night, the server logs whisper when no one is watching...</p>";

    const char *expected_secret = "<p>secret123</p>";

    printf("[*] Checking HTTP...\n");
    run_command("curl -sk http://localhost", out_http);

    // Check 1: http must NOT serve the expected page
    if (strstr(out_http, expected_html) != NULL) {
        printf("❌ please do not serve anything as http\n");
    } else {
        printf("✔️ HTTP not serving content (good)\n");
        check_http_ok = 1;
    }

    printf("\n[*] Checking HTTPS...\n");
    run_command("curl -sk https://localhost", out_https);

    // Check 2: https MUST serve the expected page
    if (strstr(out_https, expected_html) == NULL) {
        printf("❌ please serve the exact original site as https\n");
    } else {
        printf("✔️ HTTPS serves correct page\n");
        check_https_ok = 1;
    }

    printf("\n[*] Checking secret.html...\n");

    run_command("curl -sk http://localhost/secret.html", out_http_secret);
    run_command("curl -sk https://localhost/secret.html", out_https_secret);

    // Check 3: secret.html should NOT return the content
    if (strstr(out_http_secret, expected_secret) != NULL ||
        strstr(out_https_secret, expected_secret) != NULL) {
        printf("❌ please remove secret\n");
    } else {
        printf("✔️ secret file not accessible (good)\n");
        check_secret_ok = 1;
    }

    printf("\n[*] Final result:\n");

    if (check_http_ok && check_https_ok && check_secret_ok) {
        printf("FLAG: UNSAFE\n");
    } else {
        printf("Some checks failed. No flag for you.\n");
    }

    return 0;
}
