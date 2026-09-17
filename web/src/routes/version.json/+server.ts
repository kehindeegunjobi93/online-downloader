import { json } from "@sveltejs/kit";
import { getCommit, getBranch, getRemote, getVersion } from "@imput/version-info";

export async function GET() {
    try {
        return json({
            commit: await getCommit(),
            branch: await getBranch(),
            remote: await getRemote(),
            version: await getVersion()
        });
    } catch {
        return json({
            commit: "main",
            branch: "main",
            remote: "kehindeegunjobi93/online-downloader",
            version: "1.0.0"
        });
    }
}

export const prerender = false;
