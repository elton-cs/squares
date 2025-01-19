import { DojoProvider } from "@dojoengine/core";
import { Account, AccountInterface, BigNumberish, CairoOption, CairoCustomEnum, ByteArray } from "starknet";
import * as models from "./models.gen";

export function setupWorld(provider: DojoProvider) {

	const Actions_buyCoins = async (snAccount: Account | AccountInterface, amount: U256) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "Actions",
					entrypoint: "buy_coins",
					calldata: [amount],
				},
				"squares",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const Actions_startGame = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "Actions",
					entrypoint: "start_game",
					calldata: [],
				},
				"squares",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const Actions_exitSquare = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "Actions",
					entrypoint: "exit_square",
					calldata: [],
				},
				"squares",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const Actions_enterSquareOne = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "Actions",
					entrypoint: "enter_square_one",
					calldata: [],
				},
				"squares",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const Actions_enterSquareTwo = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "Actions",
					entrypoint: "enter_square_two",
					calldata: [],
				},
				"squares",
			);
		} catch (error) {
			console.error(error);
		}
	};

	return {
		Actions: {
			buyCoins: Actions_buyCoins,
			startGame: Actions_startGame,
			exitSquare: Actions_exitSquare,
			enterSquareOne: Actions_enterSquareOne,
			enterSquareTwo: Actions_enterSquareTwo,
		},
	};
}