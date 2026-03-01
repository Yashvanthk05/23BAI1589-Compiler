int x = 10;
int y;
float z = 3;
y = x * 2 + 5 / (3 - 1);
if (y >= 15) {
    x = y + 4;
}
else {
    x = y - 2;
}
while (x != 100) {
    x = x + 10;
    if (x > 50) {
        z = z * 2;
    }
    else {
        z = z + 1;
    }
}
return x;
