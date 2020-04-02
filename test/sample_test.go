package sample

import (
	"testing"
)

func Test_Plus(t *testing.T) {
	type args struct {
		a int
		b int
	}
	tests := []struct {
		name string
		args args
		want int
	}{
		{
			name: "1+1",
			args: args{a: 1, b: 1},
			want: 2,
		},
		{
			name: "1+2",
			args: args{a: 1, b: 2},
			want: 3,
		},
		{
			name: "2+0",
			args: args{a: 2, b: 0},
			want: 3,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Plus(tt.args.a, tt.args.b); got != tt.want {
				t.Errorf("Plus() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestPlus2(t *testing.T) {
	got := Plus(1, 1)
	if got != 2 {
		t.Error("Oh...")
	}
}
