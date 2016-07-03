const size: usize = 10;
const cellnum: usize = (size+2)*(size+2) ;

pub fn run(){

    let mut cells: [i32; cellnum] = [1; cellnum];
    let mut newcells: [i32; cellnum] = [1; cellnum];

    for i in 1..2 {
        if update(&cells,&newcells) {
        } else {
            break;
        }
    }

}

pub fn update(cells: &[i32; cellnum],newcells: &[i32; cellnum]) -> bool{
    let s: i32 = (size+1) as i32;
    let mut sum = 0;

    for x in s .. 2*s {
        for y in 1..s {
            let ux = x as usize;
            let uy = y as usize;
            sum = neighbors(cells,ux,uy);

            let temp: i32 = if cells[ux+size*uy] == 1 {
                                 if sum == 2 || sum == 3 { 1 } else {0}
                             } else {
                                 if sum == 3 { 1 } else {0}
                             };
        }
    }
    return true;
}

fn neighbors(cells: &[i32; cellnum] ,x: usize , y: usize) -> i32 {

    let population : i32;
    let mut count = -cells[ (x + size*y) as usize ];
    for dx in -1..2 {
        for dy in -1..2 {
            let nx : usize = (x as i32 + dx) as usize;
            let ny : usize = (y as i32 + dy) as usize;
            count = count + cells[nx + ny*size];
        }
    }

    population = count;
    return population;
}
