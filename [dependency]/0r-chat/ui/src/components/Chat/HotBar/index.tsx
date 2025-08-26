import useData from "../../../hooks/useData";
import type { MouseEvent, FC } from "react";

interface HotBarItem {
  command: string;
  label: string;
}

type HotBarProps = {
  onClickHotbar: (event: MouseEvent<HTMLButtonElement>, command: string) => void;
};

export const HotBar: FC<HotBarProps> = ({ onClickHotbar }) => {
  const { hotbarItems, activeHotbar, setActiveHotbar } = useData();

  const handleHotbarClick = (
    e: MouseEvent<HTMLButtonElement>,
    command: string
  ) => {
    e.preventDefault();
    setActiveHotbar(command);
    onClickHotbar(e, command !== "" ? "/" + command + " " : command);
  };

  return (
    <>
      <div className="flex items-center justify-between">
        {hotbarItems.map((item: HotBarItem, i: number) => (
          <button
            className={`w-full border-b-2 transition-colors h-[30px] hover:bg-2d/70 hover:border-b-white ${
              activeHotbar === item.command
                ? "border-b-white bg-2d/70"
                : "border-b-46 bg-0f/70"
            }`}
            type="button"
            key={i}
            onClick={(e: MouseEvent<HTMLButtonElement>) => handleHotbarClick(e, item.command)}
          >
            <h1 className="uppercase text-white font-medium text-[11px]">
              {item.label}
            </h1>
          </button>
        ))}
      </div>
    </>
  );
};
