<script lang="ts">
  import svelteLogo from "./assets/svelte.svg";
  import viteLogo from "/vite.svg";
  import Counter from "./lib/Counter.svelte";
  import { onMount } from "svelte";

  import { RpcProvider, Contract, AccountInterface } from "starknet";
  import Controller from "@cartridge/controller";
  import { type SessionPolicies } from "@cartridge/controller";

  import { init, type SchemaType, type SDK } from "@dojoengine/sdk";
  import {
    type Bomba,
    type BombaValue,
    type Coins,
    type CoinsValue,
    type Square,
    type SquareList,
    type SquareListValue,
    type SquareValue,
    schema,
  } from "./dojo/typescript/models.gen";
  import { dojoConfig } from "./dojo/dojoConfig";

  const rpcUrl = "https://api.cartridge.gg/x/squares/katana";

  let controller = new Controller({
    rpc: rpcUrl,
  });
  let connectedController: Controller | undefined = $state(undefined);
  let controllerUsername: string | undefined = $state(undefined);
  let loading: boolean = $state(false);

  let sdk: SDK<SchemaType>;
  onMount(async () => {
    sdk = await init<SchemaType>(
      {
        client: {
          rpcUrl: rpcUrl,
          toriiUrl: "http://localhost:8080",
          relayUrl: "/ip4/127.0.0.1/tcp/9090/tcp/80",
          worldAddress: dojoConfig.manifest.world.address,
        },
        domain: {
          name: "Squares",
          version: "1.0.0",
          chainId: "KATANA",
          revision: "1",
        },
      },
      schema,
    );

    if (await controller.probe()) {
      // auto connect
      await connectController();
    }
    loading = false;
  });

  async function connectController() {
    try {
      const res = await controller.connect();
      if (res) {
        connectedController = controller;
        // executeAccount = controller.account;
        controllerUsername = await controller.username();
        // mainContract = new Contract(
        //   mainContractClass.abi,
        //   mainContractAddr,
        //   executeAccount,
        // );
        // if (executeAccount) {
        //   mainContract.connect(executeAccount);
        //   updatedPoints = await mainContract.get_points(executeAccount.address);
        //   previousPoints = updatedPoints;
        // }
      }
    } catch (e) {
      console.log(e);
    }
  }

  function disconnectController() {
    controller.disconnect();
    connectedController = undefined;
    controllerUsername = undefined;
  }
</script>

<main>
  <div>
    <a href="https://vite.dev" target="_blank" rel="noreferrer">
      <img src={viteLogo} class="logo" alt="Vite Logo" />
    </a>
    <a href="https://svelte.dev" target="_blank" rel="noreferrer">
      <img src={svelteLogo} class="logo svelte" alt="Svelte Logo" />
    </a>
  </div>
  <h1>Vite + Svelte</h1>

  <div class="card">
    <Counter />
  </div>

  <button onclick={connectController}>Connect</button>
  <button onclick={disconnectController}>Disconnect</button>
  <p>Connected: {connectedController ? "Yes" : "No"}</p>
  <p>Username: {controllerUsername}</p>

  <p>
    Check out <a
      href="https://github.com/sveltejs/kit#readme"
      target="_blank"
      rel="noreferrer">SvelteKit</a
    >, the official Svelte app framework powered by Vite!
  </p>

  <p class="read-the-docs">Click on the Vite and Svelte logos to learn more</p>
</main>

<style>
  .logo {
    height: 6em;
    padding: 1.5em;
    will-change: filter;
    transition: filter 300ms;
  }
  .logo:hover {
    filter: drop-shadow(0 0 2em #646cffaa);
  }
  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00aa);
  }
  .read-the-docs {
    color: #888;
  }
</style>
