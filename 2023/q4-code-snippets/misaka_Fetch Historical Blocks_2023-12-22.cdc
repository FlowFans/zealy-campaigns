async function getBlocks() {
  try {
    const height = "63253147";

    const response = await fetch(
      `https://api.findlabs.io/historical/api/rest/blocks?height=${height}`
    );
    const json = await response.json();
    console.log(json);
  } catch (error) {
    console.log(error);
  }
}

getBlocks();
