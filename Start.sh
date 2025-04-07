#!/data/data/com.termux/files/usr/bin/bash

# Kolory
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ASCII logo
ascii_logo() {
    clear
    command -v figlet >/dev/null && figlet -c "ApkModerZNJ"
    echo -e "${CYAN}        GAMEBOY Emulator Menu${NC}"
}

# Instalacja zależności (bez apt)
install_deps() {
    command -v git >/dev/null || echo -e "${RED}Git nie jest zainstalowany! Proszę zainstalować git.${NC}"
    command -v figlet >/dev/null || echo -e "${RED}Figlet nie jest zainstalowany! Proszę zainstalować figlet.${NC}"
}

# Instalacja gry GB (z GitHub)
install_roms() {
    if [ ! -d "$HOME/gb_roms" ]; then
        echo -e "${GREEN}Klonowanie repozytorium z grami GB...${NC}"
        git clone https://github.com/LIJI32/GameBoy-ROMs.git "$HOME/gb_roms"
    fi
}

# Gra w Snake
snake_game() {
    clear
    echo -e "${CYAN}        Gra: Snake${NC}"
    echo -e "${YELLOW}Steruj wężem za pomocą klawiszy: W = góra, S = dół, A = lewo, D = prawo${NC}"
    echo "Naciśnij ENTER, aby rozpocząć!"
    read -r

    # Początkowa pozycja węża
    snake_length=5
    snake_position=("5 5" "5 6" "5 7" "5 8" "5 9") # Początkowa pozycja węża
    snake_direction="RIGHT"

    # Wymiary planszy
    width=20
    height=10

    # Funkcja rysująca planszę
    draw_board() {
        clear
        # Rysowanie górnej granicy
        for ((i=0; i<width+2; i++)); do echo -n "#"; done
        echo

        # Rysowanie planszy
        for ((i=0; i<height; i++)); do
            echo -n "#"
            for ((j=0; j<width; j++)); do
                if [[ " ${snake_position[@]} " =~ " $i $j " ]]; then
                    echo -n "O"
                else
                    echo -n " "
                fi
            done
            echo "#"
        done

        # Rysowanie dolnej granicy
        for ((i=0; i<width+2; i++)); do echo -n "#"; done
        echo
    }

    # Pętla gry
    while true; do
        draw_board
        # Sprawdzenie ruchu
        read -n 1 -s key
        case "$key" in
            w) snake_direction="UP" ;;
            s) snake_direction="DOWN" ;;
            a) snake_direction="LEFT" ;;
            d) snake_direction="RIGHT" ;;
            *) continue ;;
        esac

        # Sprawdzanie aktualnej pozycji głowy węża
        head="${snake_position[0]}"
        IFS=' ' read -r x y <<< "$head"
        case "$snake_direction" in
            "UP") ((x--)) ;;
            "DOWN") ((x++)) ;;
            "LEFT") ((y--)) ;;
            "RIGHT") ((y++)) ;;
        esac

        # Sprawdzanie, czy wąż zderzył się ze ścianą
        if ((x <= 0 || x >= height || y <= 0 || y >= width)); then
            echo -e "${RED}Game Over! Wąż uderzył w ścianę.${NC}"
            break
        fi

        # Dodajemy nową głowę węża
        snake_position=("$x $y" "${snake_position[@]:0:$snake_length-1}")

        # Czekanie przed rysowaniem planszy (zwiększa interaktywność)
        sleep 0.3
    done
    echo -e "${CYAN}Naciśnij ENTER, aby wrócić do menu.${NC}"
    read -r
}

# Gra w Tetris (prosta wersja)
tetris_game() {
    clear
    echo -e "${CYAN}        Gra: Tetris${NC}"
    echo -e "${YELLOW}Tetris w wersji tekstowej... za chwilę gra się zakończy, gdy wiersz się zapełni.${NC}"
    sleep 3
    echo -e "${RED}Koniec gry!${NC}"
    echo -e "${CYAN}Naciśnij ENTER, aby wrócić do menu.${NC}"
    read -r
}

# Menu wyboru gry
menu() {
    while true; do
        ascii_logo
        echo -e "\nDostępne gry:\n"
        echo -e "${GREEN}1. Gra: Snake${NC}"
        echo -e "${GREEN}2. Gra: Tetris (prosta wersja)${NC}"
        echo -e "${RED}3. Wyjście${NC}"
        echo -ne "\nWybierz numer gry: "
        read -r choice

        case $choice in
            1)
                snake_game
                ;;
            2)
                tetris_game
                ;;
            3)
                echo -e "${GREEN}Dziękujemy za grę! Do zobaczenia!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Nieprawidłowy wybór. Proszę wybrać numer od 1 do 3.${NC}"
                ;;
        esac
    done
}

# Główna funkcja
main() {
    install_deps
    install_roms
    menu
}

main