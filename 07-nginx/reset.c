#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

#define SECRET_PATH "/var/www/html/secret.html"
#define SECRET_CONTENT "<p>secret123</p>\n"

int file_exists(const char *path) {
    struct stat st;
    return stat(path, &st) == 0;
}

int main() {
    int ret;

    // 1. Copy default nginx conf
    printf("[*] Copying default nginx config...\n");
    ret = system("sudo cp /etc/defaultnginxconf/default /etc/nginx/sites-enabled/default");
    if (ret != 0) {
        fprintf(stderr, "Error copying nginx config\n");
        // but continue anyway
    } else {
        printf("✔️ Nginx config copied\n");
    }

    // 2. Create secret file if missing
    printf("[*] Checking secret file...\n");
    if (!file_exists(SECRET_PATH)) {
        printf("Secret file not found, creating...\n");
        ret = system("sudo mkdir -p /var/www/html");
        if (ret != 0) {
            fprintf(stderr, "Error creating directory\n");
            return 1;
        }

        // Create secret.html with content
        FILE *f = popen("sudo tee /var/www/html/secret.html > /dev/null", "w");
        if (!f) {
            fprintf(stderr, "Error creating secret file\n");
            return 1;
        }
        fputs(SECRET_CONTENT, f);
        pclose(f);

        ret = system("sudo chmod 644 /var/www/html/secret.html");
        if (ret != 0) {
            fprintf(stderr, "Error setting permissions on secret file\n");
            return 1;
        }

        printf("✔️ Secret file created\n");
    } else {
        printf("Secret file exists, skipping creation\n");
    }

    // 3. Remove localhost.pem and localhost-key.pem anywhere
    printf("[*] Removing localhost.pem and localhost-key.pem... this might take some time...\n");
    ret = system("sudo find / -type f \\( -name localhost.pem -o -name localhost-key.pem \\) -exec rm -f {} + 2>/dev/null");
    if (ret != 0) {
        fprintf(stderr, "Error running find to delete cert files, or not this is buggy :D\n");
    }
    printf("✔️ Removed localhost.pem and localhost-key.pem files\n");

    printf("[*] Reloading nginx...\n");
    int ret_reload = system("sudo systemctl restart nginx");
    if (ret_reload != 0) {
        fprintf(stderr, "Error restarting nginx\n");
    } else {
        printf("✔️ nginx restarting successfully\n");
    }

    printf("\nReset complete.\n");
    return 0;
}
