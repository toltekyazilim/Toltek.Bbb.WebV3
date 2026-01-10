window.clipboardInterop = {
    readText: async () => {
        return await navigator.clipboard.readText();
    },
    writeText: async (text) => {
        await navigator.clipboard.writeText(text);
    }
};