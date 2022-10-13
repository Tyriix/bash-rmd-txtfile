#!/bin/bash
cdw() { local d=`wslpath "$1"`; cd "$d"; }
count=0;

stage1 (){
    echo "Please enter the text file name."
    read file

    if [[ ! -f $file ]]; then
        echo "Text file not found."
        echo "Try again."
        stage1
    else
        break;
    fi

    count=0;

    while IFS= read -r line
    do
        readarray -t pLines < "$file"
    done < "$file"

    for arrayLine in "${pLines[@]}"
    do
        let "count++";
        echo "$count $arrayLine"
    done

}

stage2 (){
    echo ""
    echo "To add a text enter a"
    echo "To modify text enter m"
    echo "To delete text enter d"
    read choice
}

stage3 (){
    if [[ "$choice" == "a" ]]; then
        count=0;

        echo "Enter after which line you want to add text"
        read lineNo
        echo "Enter the text you want to add"
        read newText

      
        while true; do
            read -p "Are you sure you want to add this line? (y/n) " yesno
            case $yesno in
                [Yy]* ) 
                    break;;
                [Nn]* ) 
                    echo "Exiting application..."
                    exit 0;; 
                * ) 
                    echo "Try Again ";;
            esac
        done

        pLines=( "${pLines[@]:0:(($lineNo))}" "${newText}" "${pLines[@]:$lineNo}" )
        printf "%s\n" "${pLines[@]}" >  "$file"

        for arrayLine in "${pLines[@]}"
        do
            let "count++";
            echo "$count $arrayLine"
        done

        completedA
    elif [[ "$choice" == "m" ]]; then
        count=0;

        echo "Enter in which line you want to modify the text"
        read lineNo
        echo "Enter the new text you want to add"
        read modifiedText

        while true; do
            read -p "Are you sure you want to modify this line? (y/n) " yesno
            case $yesno in
                [Yy]* ) 
                    break;;
                [Nn]* ) 
                    echo "Exiting application..."
                    exit 2;;
                * ) 
                    echo "Try Again ";;
            esac
        done

        pLines[$lineNo-1]=$modifiedText
        printf "%s\n" "${pLines[@]}" >  "$file"

        for arrayLine in "${pLines[@]}"
        do
            let "count++";
            echo "$count $arrayLine"
        done

        completedM
    elif [[ "$choice" == "d" ]]; then
        count=0;
        echo "Enter which line you want to delete from the text"
        read lineNo

        while true; do
            read -p "Are you sure you want to delete this line? (y/n) " yesno
            case $yesno in
                [Yy]* ) 
                    break;;
                [Nn]* ) 
                    echo "Exiting application..."
                    exit 1;;
                * ) 
                    echo "Try Again ";;
            esac
        done
        unset pLines[$lineNo-1]
        printf "%s\n" "${pLines[@]}" >  "$file"

        for arrayLine in "${pLines[@]}"
        do
                let "count++";
                echo "$count $arrayLine"
        done

        completedD
    fi
}

completedA (){
    echo "Text added successfully"
    echo "Returning to start..."
    stage1
    stage2
    stage3
}

completedM (){
    echo "Text modified successfully"
    echo "Returning to start..."
    stage1
    stage2
    stage3
}

completedD (){
    echo "Text deleted successfully"
    echo "Returning to start..."
    stage1
    stage2
    stage3
}

main (){
    stage1
    stage2
    stage3
}
main