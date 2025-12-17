export interface Animatable<T> {
    readonly current: T;
    set(newValue: T): void;
}
export declare function animatable<T>(initialValue: T, opts?: {
    equals?: (a: T, b: T) => boolean;
}): Animatable<T>;
export declare const viewTransitionName: import("ember-modifier").FunctionBasedModifier<{
    Args: {
        Positional: (string | number)[];
        Named: import("ember-modifier/-private/signature").EmptyObject;
    };
    Element: HTMLElement;
}>;
//# sourceMappingURL=index.d.ts.map