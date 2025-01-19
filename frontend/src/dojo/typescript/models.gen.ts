import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { BigNumberish } from 'starknet';

type WithFieldOrder<T> = T & { fieldOrder: string[] };

// Type definition for `squares::models::bomba::Bomba` struct
export interface Bomba {
	id: boolean;
	tick: BigNumberish;
	tick_limit: BigNumberish;
}

// Type definition for `squares::models::bomba::BombaValue` struct
export interface BombaValue {
	tick: BigNumberish;
	tick_limit: BigNumberish;
}

// Type definition for `squares::models::coins::Coins` struct
export interface Coins {
	owner: string;
	balance: BigNumberish;
}

// Type definition for `squares::models::coins::CoinsValue` struct
export interface CoinsValue {
	balance: BigNumberish;
}

// Type definition for `squares::models::square::Square` struct
export interface Square {
	owner: string;
	square: BigNumberish;
}

// Type definition for `squares::models::square::SquareList` struct
export interface SquareList {
	square_index: BigNumberish;
	player: string;
	previous_player: string;
	next_player: string;
}

// Type definition for `squares::models::square::SquareListValue` struct
export interface SquareListValue {
	previous_player: string;
	next_player: string;
}

// Type definition for `squares::models::square::SquareValue` struct
export interface SquareValue {
	square: BigNumberish;
}

export interface SchemaType extends ISchemaType {
	squares: {
		Bomba: WithFieldOrder<Bomba>,
		BombaValue: WithFieldOrder<BombaValue>,
		Coins: WithFieldOrder<Coins>,
		CoinsValue: WithFieldOrder<CoinsValue>,
		Square: WithFieldOrder<Square>,
		SquareList: WithFieldOrder<SquareList>,
		SquareListValue: WithFieldOrder<SquareListValue>,
		SquareValue: WithFieldOrder<SquareValue>,
	},
}
export const schema: SchemaType = {
	squares: {
		Bomba: {
			fieldOrder: ['id', 'tick', 'tick_limit'],
			id: false,
			tick: 0,
			tick_limit: 0,
		},
		BombaValue: {
			fieldOrder: ['tick', 'tick_limit'],
			tick: 0,
			tick_limit: 0,
		},
		Coins: {
			fieldOrder: ['owner', 'balance'],
			owner: "",
			balance: 0,
		},
		CoinsValue: {
			fieldOrder: ['balance'],
			balance: 0,
		},
		Square: {
			fieldOrder: ['owner', 'square'],
			owner: "",
			square: 0,
		},
		SquareList: {
			fieldOrder: ['square_index', 'player', 'previous_player', 'next_player'],
			square_index: 0,
			player: "",
			previous_player: "",
			next_player: "",
		},
		SquareListValue: {
			fieldOrder: ['previous_player', 'next_player'],
			previous_player: "",
			next_player: "",
		},
		SquareValue: {
			fieldOrder: ['square'],
			square: 0,
		},
	},
};
export enum ModelsMapping {
	Bomba = 'squares-Bomba',
	BombaValue = 'squares-BombaValue',
	Coins = 'squares-Coins',
	CoinsValue = 'squares-CoinsValue',
	Square = 'squares-Square',
	SquareList = 'squares-SquareList',
	SquareListValue = 'squares-SquareListValue',
	SquareValue = 'squares-SquareValue',
}