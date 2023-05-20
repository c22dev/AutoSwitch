import requests

repositories = [
    "https://api.github.com/repos/CTCaer/hekate/releases/latest",
    "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest",
    "https://api.github.com/repos/rashevskyv/dbi/releases/latest",
    "https://api.github.com/repos/fortheusers/hb-appstore/releases/latest"
]

new_releases = []

for repo in repositories:
    response = requests.get(repo)
    if response.status_code == 200:
        latest_release = response.json()
        tag_name = latest_release["tag_name"]
        assets_count = len(latest_release["assets"])
        if assets_count > 0:
            new_releases.append(f"{repo.split('/')[-2]} ({tag_name})")

if new_releases:
    print("New releases found:")
    for release in new_releases:
        print(release)
else:
    print("No new releases found.")
