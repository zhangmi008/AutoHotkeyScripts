﻿GaussRand(mu := 0, sigma := 1) {
    loop {
        u1 := Random()
        u2 := 1.0 - Random()
        z := 1.7155277699214135 * (u1 - 0.5) / u2
        zz := z * z / 4.0
        if zz <= -Ln(u2)
            break
    }
    return mu + z * sigma
}

StandardDeviation(nums) {
    sum := mean := std := 0
    for v in nums
        sum += nums[A_Index]
    mean := sum / nums.Length 
    for v in nums
        std += (nums[A_Index] - mean) ** 2
    return Sqrt(std / nums.Length)
}

NormalVariate(mu := 0, sigma := 1) {
    loop {
        u1 := Random()
        u2 := 1.0 - Random()
        z := 1.7155277699214135 * (u1 - 0.5) / u2
        zz := z * z / 4.0
        if zz <= -Ln(u2)
            break
    }
    return mu + z * sigma
}

GetSelection() {
    before := A_Clipboard
    A_Clipboard := ""
    Send("^c")
    selection := ClipWait(0.2) ? A_Clipboard : ""
    A_Clipboard := before
    return selection
}

PasteSend(text) {
    before := A_Clipboard
    A_Clipboard := text
    Send("^v"), Sleep(100)
    A_Clipboard := before
}

JoinArray(arr, delimiter := "`n") {
    joint := arr.Length && arr[1]
    loop arr.Length - 1
        joint .= delimiter arr[A_Index + 1]
    return joint
}

SendText(str, window := "A") {
    ctrl := ControlGetFocus(window) || WinExist(window)
    loop parse, str
        PostMessage(0x102, ord(A_LoopField), , ctrl)
}

ScreenToClient(screenX, screenY, &clientX, &clientY, window := "A") {
    clientX := clientY := 0
    if res := DllCall("ScreenToClient", "ptr", WinExist(window), "ptr*", &pt := (screenX & 0xffffffff) | (screenY << 32)) {
        clientX := pt & 0xffffffff, clientY := pt >> 32
        if clientX > 0x7fffffff
            clientX -= 0x100000000
        if clientY > 0x7fffffff
            clientY -= 0x100000000
    }
    return res
}

ClientToScreen(clientX, clientY, &screenX, &screenY, window := "A") {
    screenX := screenY := 0
    if res := DllCall("ClientToScreen", "ptr", WinExist(window), "ptr*", &pt := (clientX & 0xffffffff) | (clientY << 32)) {
        screenX := pt & 0xffffffff, screenY := pt >> 32
        if screenX > 0x7fffffff
            screenX -= 0x100000000
        if screenY > 0x7fffffff
            screenY -= 0x100000000
    }
    return res
}

GetUnixTimestamp() {
    DllCall("GetSystemTimeAsFileTime", "uint64*", &currentTime := 0)
    return currentTime - 116444736000000000
}

GetProcessElapsedTime(pidOrName) {
    hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", false, "uint", ProcessExist(pidOrName), "ptr")
    DllCall("GetProcessTimes", "ptr", hProcess, "uint64*", &creationTime := 0, "uint64*", 0, "uint64*", 0, "uint64*", 0, "int")
    DllCall("GetSystemTimeAsFileTime", "uint64*", &currentTime := 0)
    return currentTime - creationTime ; (currentTime - creationTime) / 1e7 ms
}